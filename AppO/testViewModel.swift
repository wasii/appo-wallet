// 
//  testViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation
import Combine

enum testState {
    case none
}

class testViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<testState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<testState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    @Published var showLoader: Bool = false
    @Published var isPresentAlert: Bool = false
    @Published var apiError: String?
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
