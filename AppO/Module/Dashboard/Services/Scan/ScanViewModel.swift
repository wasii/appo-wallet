//
//  ScanViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 08/10/2024.
//

import Foundation
import SwiftUI
import Combine

enum ScanViewModelState {
    case none
}

class ScanViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ScanViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ScanViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
