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
    private var pInteractor: PINInteractorType
    private var dInteractor: DeviceBindingInteractorType
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    init(pInteractor: PINInteractorType = PINInteractor(), dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor()) {
        self.pInteractor = pInteractor
        self.dInteractor = dInteractor
    }
}


extension EnterMPINViewModel {
    func verifyPIN(mobilePin: String) async throws {
        let request: VerifyPINRequest = .init(deviceId: AppDefaults.deviceId ?? "", mobilePin: mobilePin)
        
        return try await withCheckedThrowingContinuation { continuation in
            pInteractor.verifyPIN(request: request)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else {
                        return
                    }
                    self?.isPresentAlert = true
                    self?.apiError = "Invalid Mobile PIN"
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    self?.showLoader = false
                    if response.message == "success" {
                        AppDefaults.mobilePin = mobilePin
                        self?.coordinatorStatePublisher.send(.with(.confirm))
                        continuation.resume(returning: ()) // Success without value
                    } else {
                        self?.isPresentAlert = true
                        self?.apiError = "Something went wrong!"
                        continuation.resume(throwing: NSError(domain: "PINVerification", code: 1, userInfo: [NSLocalizedDescriptionKey: "PIN verification failed"]))
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    func getDMK() async throws -> Bool  {
        let request: DataMasterKeyRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "cms_mapp_get_dmk"),
            requestData: .init(
                instId: "AP",
                mobileNum: AppDefaults.mobile ?? ""
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            dInteractor.getDataMasterKey(request: request)
                .receive(on: DispatchQueue.main) 
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else { return }
                    continuation.resume(throwing: error) // Propagate the error
                } receiveValue: { response in
                    if response.respInfo?.respStatus == 200 {
                        AppDefaults.dmk = response.respInfo?.respData?.dmk
                        AppDefaults.dmk_kcv = response.respInfo?.respData?.dmkKcv
                        continuation.resume(returning: true)
                    } else {
                        continuation.resume(returning: false)
                    }
                }
                .store(in: &self.cancellables)
        }
    }
}
