//
//  PhoneNumberVerificationViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation
import Combine
import SwiftUI


enum PhoneNumberVerificationViewModelState {
    case confirm
}
class PhoneNumberVerificationViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<PhoneNumberVerificationViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<PhoneNumberVerificationViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    private var interactor: PhoneNumberVerificationInteractorType
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    init(interactor: PhoneNumberVerificationInteractorType = PhoneNumberVerificationInteractor()) {
        self.interactor = interactor
    }
}


extension PhoneNumberVerificationViewModel {
    func sendOTP(mobPhoneNumber: String, phoneCode: String) {
        showLoader = true
        interactor.sendOTP(request: .init(mobileNumber: mobPhoneNumber, hashKey: "3w0pkWn2S4N", phoneCode: phoneCode))
            .sink { [weak self] completion in
                self?.showLoader = false
                self?.coordinatorStatePublisher.send(.with(.confirm))
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.status == "200" {
//                    self?.coordinatorStatePublisher.send(.with(.confirm))
                } else {
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                }
                self?.coordinatorStatePublisher.send(.with(.confirm))
            }
            .store(in: &cancellables)
        
    }
}
