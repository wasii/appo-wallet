//
//  ChangeTransactionPinViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum ChangeTransactionViewModelState {
    case none
}
class ChangeTransactionPinViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ChangeTransactionViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ChangeTransactionViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
