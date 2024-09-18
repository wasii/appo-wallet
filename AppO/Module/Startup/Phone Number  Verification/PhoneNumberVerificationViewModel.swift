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
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<PhoneNumberVerificationViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<PhoneNumberVerificationViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    @Published var showLoader: Bool = false
    
    init() {}
}
