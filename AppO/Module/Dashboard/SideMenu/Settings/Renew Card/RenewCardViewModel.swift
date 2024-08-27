//
//  RenewCardViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum RenewCardViewModelState {
    case none
}

class RenewCardViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<RenewCardViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<RenewCardViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
