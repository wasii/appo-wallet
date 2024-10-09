//
//  CardToCardViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum CardToCardViewModelState {
    case selectCard
}

class CardToCardViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<CardToCardViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<CardToCardViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    @Published var user: CustomerEnquiryResponseData? = nil
    @Published var selected_card: Card? = nil
    
    @Published var isDetailsFetched: Bool = false
    @Published var fetched_user: CustomerEnquiryResponseData? = nil
    
    @Published var isShowTransactionPin: Bool = false
    @Published var isShowTransactionSuccess: Bool = false
    @Published var response: CardToCardResponse?
    
    var amount: String = "000000000000"
    @Published var cardRefNum: String = ""
    @Published var maskCardNum: String = ""
    var mobileNumber: String = ""
    
    private var hInteractor: HomeInteractorType
    private var dInteractor: DeviceBindingInteractorType
    private var pInteractor: PINInteractorType
    private var tInteractor: TransactionsInteractorType
    
    init(hInteractor: HomeInteractorType = HomeInteractor(), dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor(), pInteractor: PINInteractorType = PINInteractor(), tInteractor: TransactionsInteractorType = TransactionsInteractor()) {
        self.hInteractor = hInteractor
        self.dInteractor = dInteractor
        self.pInteractor = pInteractor
        self.tInteractor = tInteractor
        self.user = AppDefaults.user
        self.selected_card = AppDefaults.selected_card
    }
}


extension CardToCardViewModel {
    func getCustomerEnquiry(mobile: String) {
        self.showLoader = true
        let request: CustomerEnquiryRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "mobile_app_cust_enq"),
            requestData: .init(
                instID: "AP",
                mobile: mobile,
                deviceNo: "12345"
            )
        )
        hInteractor.customer_enquiry(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.respInfo?.respStatus == 200 {
                    self?.fetched_user = response.respInfo?.respData
                    self?.isDetailsFetched = true
                } else {
                    print("ERROR")
                }
            }
            .store(in: &cancellables)
    }
}

extension CardToCardViewModel {
    func getDataEncryptionKey() async throws -> Bool {
        let request: DataEncryptionKeyRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "cms_mapp_get_dek"),
            requestData: .init(
                instId: "AP",
                mobileNum: AppDefaults.mobile ?? ""
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            dInteractor.getDataEncryptionKey(request: request)
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    continuation.resume(throwing: error)
                } receiveValue: { response in
                    if response.respInfo?.respStatus == 200 {
                        AppDefaults.dek = response.respInfo?.respData?.dek
                        AppDefaults.dek_kcv = response.respInfo?.respData?.dekKcv
                        continuation.resume(returning: (true))
                    } else {
                        continuation.resume(returning: (false))
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func getCardNumber() async throws -> Bool {
        let request: ShowCardNumberRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(
                requestType: "decrypt_cms_card_num"
            ),
            requestData: .init(
                instID: "AP",
                cardRefNum: cardRefNum,
                custId: fetched_user?.custID ?? "",
                mobileNum: fetched_user?.primaryMobileNum ?? ""
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            hInteractor.show_card_number(request: request)
                .sink { [weak self] completion in
                    guard case let .failure(error) = completion else { return }
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    if response.respInfo?.respStatus == 200 {
                        AppDefaults.temp_cardnumber = response.respInfo?.respData?.dCardNum
                        continuation.resume(returning: (true))
                    } else {
                        self?.isPresentAlert = true
                        self?.apiError = "Something went wrong!"
                        continuation.resume(returning: (false))
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func tranfer_card_to_card() async throws -> Bool {
        guard let encryptedKey = CryptoUtils.main() else { return false }
        let request: CardToCardRequest = .init(
            reqHeaderInfo: .init(),
            deviceInfo: .init(
                name: "iPhone 16 Pro Max",
                manufacturer: "Apple",
                model: "A3603",
                version: "18",
                os: "iOS"
            ),
            requestKey: .init(requestType: "mapp_card_cardtocard"),
            requestData: .init(
                isoReqData: .init(
                    fld11: "001118",
                    fld12: "163756",
                    fld13: "0817",
                    fld14: "2708",
                    fld18: "0601",
                    fld19: "356",
                    fld2: AppDefaults.temp_cardnumber ?? "",
                    fld22: "510",
                    fld3: "400000",
                    fld37: "422917001118",
                    fld4: self.updateAmount(with: amount),
                    fld41: "T0V0S101",
                    fld42: AppDefaults.user?.custID ?? "",
                    fld43: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                    fld44: AppDefaults.mobile ?? "",
                    fld49: "356",
                    fld51: "356",
                    fld52: encryptedKey,
                    fld56: AppDefaults.temp_cardnumber ?? "",
                    mti: "0100"
                )
            )
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            tInteractor.card_to_card(request: request)
                .sink { [weak self] completion in
                    guard case let .failure(error) = completion else { return }
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    if response.respInfo?.respStatus == 200 {
                        self?.response = response.respInfo?.respData
                        continuation.resume(returning: (true))
                    } else {
                        self?.isPresentAlert = true
                        self?.apiError = "\(response.respInfo?.rejectCode ?? "")---\(response.respInfo?.rejectShortDesc ?? "") -- \(response.respInfo?.respCode ?? "")"
                        continuation.resume(returning: (false))
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func updateAmount(with newValue: String) -> String {
        let filtered = newValue.filter { "0123456789".contains($0) }
        if filtered.count <= 12 {
            return String(repeating: "0", count: 12 - filtered.count) + filtered
        }
        return "000000000000"
    }
}
