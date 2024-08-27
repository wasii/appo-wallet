//
//  MyQRCodeViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import SwiftUI
import Combine

enum MyQRCodeViewModelState {
    case none
}
class MyQRCodeViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<MyQRCodeViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<MyQRCodeViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
