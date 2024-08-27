//
//  CardToCardViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum CardToCardViewModelState {
    case none
}

class CardToCardViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<CardToCardViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<CardToCardViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
