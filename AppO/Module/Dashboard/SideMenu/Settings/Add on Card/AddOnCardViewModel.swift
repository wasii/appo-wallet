//
//  AddOnCardViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 27/08/2024.
//

import Foundation
import Combine

enum AddOnCardViewModelState {
    case none
}

class AddOnCardViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<AddOnCardViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<AddOnCardViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
