//
//  HomeScreenViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine
import SwiftUI


enum HomeScreenViewModelState {
    case navigateToManageAccounts
    case navigateToMyQRCode
    case navigateToCardtoCard
    case navigateToPayments
    case navigateToSettings
    case logout
}
class HomeScreenViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<HomeScreenViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<HomeScreenViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    @Published var customer_enquiry: CustomerEnquiryResponseData?
    @Published var selected_card: Card?
    @Published var cardNumber: String = ""
    @Published var expiryDate: String = ""
    
    @Published private var timeRemaining = 10
    @Published private var timerActive = false
    private var timerCancellable: AnyCancellable?
    
    private var hInteractor: HomeInteractorType
    private var dInteractor: DeviceBindingInteractorType
    private var pInteractor: PINInteractorType
    
    init(hInteractor: HomeInteractorType = HomeInteractor(),
         dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor(),
         pInteractor: PINInteractorType = PINInteractor()) {
        self.hInteractor = hInteractor
        self.dInteractor = dInteractor
        self.pInteractor = pInteractor
    }
}

extension HomeScreenViewModel {
    func getCustpmerEnquiry() {
        self.showLoader = true
        let request: CustomerEnquiryRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "mobile_app_cust_enq"),
            requestData: .init(
                instID: "AP",
                mobile: AppDefaults.mobile ?? AppDefaults.user?.primaryMobileNum ?? "",
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
                    AppDefaults.user = response.respInfo?.respData
                    AppDefaults.selected_card = response.respInfo?.respData?.cardList?.first
                    self?.customer_enquiry = response.respInfo?.respData
                    self?.selected_card = self?.customer_enquiry?.cardList?.first
                    self?.cardNumber = self?.selected_card?.maskCardNum ?? ""
                    self?.expiryDate = self?.convertDateToMonthYear(self?.selected_card?.expDate ?? "") ?? ""
                    AppDefaults.newUser = nil
                } else {
                    print("ERROR")
                }
            }
            .store(in: &cancellables)
    }
    
    fileprivate func formatCreditCardNumber(_ number: String) -> String {
        let trimmedString = number.replacingOccurrences(of: " ", with: "")
        var formattedString = ""
        for (index, character) in trimmedString.enumerated() {
            if index != 0 && index % 4 == 0 {
                formattedString.append(" ")
            }
            formattedString.append(character)
        }
        return formattedString
    }
    func convertDateToMonthYear(_ date: String) -> String? {
        guard date.count == 8 else {
            return nil
        }
        let startIndex = date.index(date.startIndex, offsetBy: 2)
        let endIndex = date.index(date.startIndex, offsetBy: 4)
        
        let month = String(date[startIndex..<endIndex])
        let year = String(date.suffix(4))
        
        
        return "\(month)/\(year)"
    }
}

extension HomeScreenViewModel {
    func getDataEncryptionKey() async throws -> Bool {
        DispatchQueue.main.async {
            self.showLoader = true
        }
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
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else { return }
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
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
                cardRefNum: selected_card?.cardRefNum ?? "",
                custId: AppDefaults.user?.custID ?? "",
                mobileNum: AppDefaults.user?.primaryMobileNum ?? ""
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            hInteractor.show_card_number(request: request)
                .sink { [weak self] completion in
                    self?.showLoader = false
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
    
    func setCardPin() async throws -> Bool  {
        guard let encryptedKey = CryptoUtils.main() else { return false }
        print(encryptedKey)
        let request: SetCardPINRequest = .init(
            reqHeaderInfo: .init(),
            deviceInfo: .init(
                name: "iPhone 16 Pro Max",
                manufacturer: "Apple",
                model: "A3603",
                version: "18",
                os: "iOS"
            ),
            requestKey: .init(
                requestType: "mapp_setpin"
            ),
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
                    fld3: "940001",
                    fld37: "422917001118",
                    fld41: "T0V0S101",
                    fld42: AppDefaults.user?.custID ?? "",
                    fld43: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                    fld44: AppDefaults.mobile ?? "",
                    fld49: "356",
                    fld51: "356",
                    fld52: encryptedKey,
                    mti: AppDefaults.temp_pin ?? ""
                )
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            pInteractor.set_card_pin(request: request)
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else { return }
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    if response.respInfo?.respStatus == 200 {
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
}
