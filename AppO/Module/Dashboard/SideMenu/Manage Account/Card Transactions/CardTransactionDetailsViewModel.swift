//
//  CardTransactionDetailsViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

class CardTransactionDetailsViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ManageAccountViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ManageAccountViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
