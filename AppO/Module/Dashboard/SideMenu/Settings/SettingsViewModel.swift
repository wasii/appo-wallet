//
//  SettingsViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum SettingsViewModelState {
    case none
}

class SettingsViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<SettingsViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<SettingsViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
