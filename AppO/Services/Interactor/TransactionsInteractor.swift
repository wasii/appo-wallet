//
//  TransactionsInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 02/10/2024.
//

import Combine
import Foundation

protocol TransactionsInteractorType {
    func card_to_card(request: CardToCardRequest) -> AnyPublisher<ChangePINBaseResponse<CardToCardResponse>, NetworkError>
}

class TransactionsInteractor: TransactionsInteractorType {
    private var networkManager: NetworkManager<TransactionsAPI>
    
    init(providerType: NetworkManagerProviderType<TransactionsAPI> = .live) {
        networkManager = NetworkManager<TransactionsAPI>(with: providerType)
    }
    
    func card_to_card(request: CardToCardRequest) -> AnyPublisher<ChangePINBaseResponse<CardToCardResponse>, NetworkError> {
        let target: TransactionsAPI = .card_to_card(parameters: request.dictionary ?? [:])
        return networkManager
            .SystemPINRequest(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
