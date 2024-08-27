//
//  VerifyOTPViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation
import Combine

enum VerifyOTPViewModelState {
    case none
}

class VerifyOTPViewModel: ObservableObject {
    var countryCode: String
    var phoneNumber: String
    
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<VerifyOTPViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<VerifyOTPViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []

    init(countryCode: String, phoneNumber: String) {
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
}
