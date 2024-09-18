//
//  SetupMobilePinViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 19/08/2024.
//

import Foundation
import Combine

enum SetupMonbilePinViewModelState {
    case none
}

class SetupMobilePinViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<SetupMonbilePinViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<SetupMonbilePinViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    init() {}
}
