//
//  VerifyOTPViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation
import Combine

enum VerifyOTPViewModelState {
    case verify
}

class VerifyOTPViewModel: ObservableObject {
    var countryCode: String
    var phoneNumber: String
    var countryFlag: String
    
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<VerifyOTPViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<VerifyOTPViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []

    init(countryCode: String, phoneNumber: String, countryFlag: String) {
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.countryFlag = countryFlag
    }
}
