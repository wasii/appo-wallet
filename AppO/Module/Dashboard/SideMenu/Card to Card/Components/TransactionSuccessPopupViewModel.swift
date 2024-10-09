//
//  TransactionSuccessPopupViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 09/10/2024.
//

import Foundation
import Combine

enum TransactionSuccessPopupViewModelState {
    case share
    case close
}

class TransactionSuccessPopupViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<TransactionSuccessPopupViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<TransactionSuccessPopupViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
}
