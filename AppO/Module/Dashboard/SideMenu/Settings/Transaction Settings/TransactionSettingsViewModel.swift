//
//  TransactionSettingsViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum TransactionSettingsViewModelState {
    case none
}

class TransactionSettingsViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<TransactionSettingsViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<TransactionSettingsViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
