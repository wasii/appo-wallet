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
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    init(vInteractor: VerifyPINInteractorType = VerifyPINInteractor()) {
        self.vInteractor = vInteractor
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
                } else {
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                }
            }
            .store(in: &cancellables)
    }
}
