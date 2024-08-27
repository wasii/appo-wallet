//
//  ManageAccountViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import SwiftUI
import Combine

enum ManageAccountViewModelState {
    case showTransactions
}
class ManageAccountViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ManageAccountViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ManageAccountViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
