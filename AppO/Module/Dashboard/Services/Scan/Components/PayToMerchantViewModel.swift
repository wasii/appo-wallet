//
//  PayToMerchantViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 08/10/2024.
//

import Foundation
import Combine

enum PayToMerchantViewModelState {
    case none
}

class PayToMerchantViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<PayToMerchantViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<PayToMerchantViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    private var cancellables: [AnyCancellable] = []
    
    init() {}
}
