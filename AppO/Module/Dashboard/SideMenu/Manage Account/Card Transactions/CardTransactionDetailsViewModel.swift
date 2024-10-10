//
//  CardTransactionDetailsViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

class CardTransactionDetailsViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ManageAccountViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ManageAccountViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    var mini_statement: GetMiniStatementResponse?
    init(mini_statement: GetMiniStatementResponse?) {
        self.mini_statement = mini_statement
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
}


extension CardTransactionDetailsViewModel {
    
}

