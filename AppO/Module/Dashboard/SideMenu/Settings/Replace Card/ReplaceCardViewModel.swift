//
//  ReplaceCardViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum ReplaceCardViewModelState {
    case none
}
class ReplaceCardViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ReplaceCardViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ReplaceCardViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
