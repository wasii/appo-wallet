//
//  PhoneNumberVerificationViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation
import Combine


enum PhoneNumberVerificationViewModelState {
    case confirm
}
class PhoneNumberVerificationViewModel: ObservableObject {
    var countryCode: String = ""
    var phoneNumber: String = ""
    
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<PhoneNumberVerificationViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<PhoneNumberVerificationViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
