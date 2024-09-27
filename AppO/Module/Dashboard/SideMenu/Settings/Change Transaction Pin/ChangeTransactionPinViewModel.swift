//
//  ChangeTransactionPinViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum ChangeTransactionViewModelState {
    case none
}
class ChangeTransactionPinViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ChangeTransactionViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ChangeTransactionViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    private var pInteractor: PINInteractorType
    private var dInteractor: DeviceBindingInteractorType
    
    init(pInteractor: PINInteractorType = PINInteractor(),
         dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor()) {
        self.pInteractor = pInteractor
        self.dInteractor = dInteractor
    }
}


extension ChangeTransactionPinViewModel {
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
    
    func setCardPin(oldPin: String, newPin: String) async throws -> Bool  {
        let request: UpdateCardPINRequest = .init(
            reqHeaderInfo: .init(),
            deviceInfo: .init(
                name: "iPhone 16 Pro Max",
                manufacturer: "Apple",
                model: "A3603",
                version: "18",
                os: "iOS"
            ),
            requestKey: .init(
                requestType: "mapp_pin_chg"
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
                    fld3: "940000",
                    fld37: "422917001118",
                    fld41: "T0V0S101",
                    fld42: AppDefaults.user?.custID ?? "",
                    fld43: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                    fld44: AppDefaults.mobile ?? "",
                    fld49: "356",
                    fld51: "356",
                    fld52: oldPin,
                    fld53: newPin,
                    mti: AppDefaults.temp_pin ?? ""
                )
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            pInteractor.update_card_pin(request: request)
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else { return }
                    self?.isPresentAlert = true
                    self?.apiError = "Invalid OTP!"
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    if response.respInfo?.respStatus == 200 {
                        self?.isPresentAlert = true
                        self?.apiError = "Card PIN changed successfully"
                        continuation.resume(returning: (true))
                    } else if response.respInfo?.respStatus == 500 {
                        self?.isPresentAlert = true
                        self?.apiError = response.respInfo?.respDesc
                        continuation.resume(returning: (false))
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
