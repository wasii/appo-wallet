//
//  EnterMPINViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation
import Combine

enum EnterMPINViewModelState {
    case confirm
    case createNewAccount
    case bindDevice
}

class EnterMPINViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<EnterMPINViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<EnterMPINViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    private var vInteractor: VerifyPINInteractorType
    private var dInteractor: DeviceBindingInteractorType
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    init(vInteractor: VerifyPINInteractorType = VerifyPINInteractor(), dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor()) {
        self.vInteractor = vInteractor
        self.dInteractor = dInteractor
    }
}


extension EnterMPINViewModel {
    func verifyPIN(mobilePin: String) {
        let request: VerifyPINRequest = .init(mobilePin: mobilePin)
        vInteractor.verifyPIN(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
//                self?.coordinatorStatePublisher.send(.with(.confirm))
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.status == "200" {
                    self?.coordinatorStatePublisher.send(.with(.confirm))
                    AppDefaults.mobilePin = mobilePin
                } else {
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                }
            }
            .store(in: &cancellables)
    }
    
    func getDMK(handler: @escaping(Bool) -> Void) {
        self.showLoader = true
        let request: DataMasterKeyRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "cms_mapp_get_dmk"),
            requestData: .init(
                instId: "AP",
                mobileNum: AppDefaults.mobile ?? ""
            )
        )
        dInteractor.getDataMasterKey(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
                handler(false)
            } receiveValue: { response in
                if response.respInfo?.respStatus == 200 {
                    AppDefaults.dmk = response.respInfo?.respData?.dmk
                    AppDefaults.dmk_kcv = response.respInfo?.respData?.dmkKcv
                    handler(true)
                } else {
                    handler(false)
                }
            }
            .store(in: &cancellables)

    }
}
