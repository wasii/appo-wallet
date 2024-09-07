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
    case forgetPin
}

class EnterMPINViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<EnterMPINViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<EnterMPINViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
