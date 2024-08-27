//
//  CardStatusViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum CardStatusViewModelState {
    case none
}

class CardStatusViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<CardStatusViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<CardStatusViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
