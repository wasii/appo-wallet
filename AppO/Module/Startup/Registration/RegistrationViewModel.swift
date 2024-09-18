//
//  RegistrationViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 19/08/2024.
//

import Foundation
import Combine

enum RegistrationViewModelState {
    case none
}

class RegistrationViewModel: ObservableObject {
    var countryFlag: String
    var countryCode: String
    var phoneNumber: String
    
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<RegistrationViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<RegistrationViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    
    init(countryFlag: String, countryCode: String, phoneNumber: String) {
        self.countryFlag = countryFlag
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
}

