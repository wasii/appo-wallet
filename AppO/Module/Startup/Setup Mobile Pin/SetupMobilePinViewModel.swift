//
//  SetupMobilePinViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 19/08/2024.
//

import Foundation
import Combine

enum SetupMonbilePinViewModelState {
    case verify
}

class SetupMobilePinViewModel: ObservableObject {
    var countryFlag: String
    var countryCode: String
    var phoneNumber: String
    
    var mobilePin: String = ""
    
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<SetupMonbilePinViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<SetupMonbilePinViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    var interactor: SetupMobilePinInteractorType
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    init(interactor: SetupMobilePinInteractorType = SetupMobilePinInteractor(), countryFlag: String, countryCode: String, phoneNumber: String) {
        self.interactor = interactor
        self.countryFlag = countryFlag
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
}


extension SetupMobilePinViewModel {
    func updatePIN() {
        showLoader = true
        interactor.savePIN(request: .init(mobilePin: mobilePin))
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.status == "200" {
                    self?.coordinatorStatePublisher.send(.with(.verify))
                }
                else {
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                }
            }
            .store(in: &cancellables)
    }
}
