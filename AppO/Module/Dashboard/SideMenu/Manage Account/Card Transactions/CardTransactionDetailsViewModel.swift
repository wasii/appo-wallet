//
//  CardTransactionDetailsViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

class CardTransactionDetailsViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ManageAccountViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ManageAccountViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
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
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
}


extension CardTransactionDetailsViewModel {
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
                cardRefNum: AppDefaults.selected_card?.cardRefNum ?? "",
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
    
    func get_mini_statement() async throws -> Bool  {
        guard let encryptedKey = CryptoUtils.main() else { return false }
        let request: GetMiniStatementRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "mapp_card_mini_stmt"),
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
                    mti: AppDefaults.newPIN ?? ""
                )
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            pInteractor.get_mini_statement(request: request)
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

