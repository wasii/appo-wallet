//
//  PINInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 27/09/2024.
//

import Combine
import Foundation

protocol PINInteractorType {
    func verifyPIN(request: VerifyPINRequest) -> AnyPublisher<VerifyPINResponse, NetworkError>
    func set_card_pin(request: SetCardPINRequest) -> AnyPublisher<ChangePINBaseResponse<SetCardPINResponse>, NetworkError>
    func update_card_pin(request: UpdateCardPINRequest) -> AnyPublisher<ChangePINBaseResponse<UpdateCardPINResponse>, NetworkError>
    func get_mini_statement(request: GetMiniStatementRequest) -> AnyPublisher<ChangePINBaseResponse<UpdateCardPINResponse>, NetworkError>
}

class PINInteractor: PINInteractorType {
    private var networkManager: NetworkManager<PINAPIs>
    
    init(providerType: NetworkManagerProviderType<PINAPIs> = .live) {
        networkManager = NetworkManager<PINAPIs>(with: providerType)
    }
    
    func verifyPIN(request: VerifyPINRequest) -> AnyPublisher<VerifyPINResponse, NetworkError> {
        let target: PINAPIs = .verifyPIN(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func set_card_pin(request: SetCardPINRequest) -> AnyPublisher<ChangePINBaseResponse<SetCardPINResponse>, NetworkError> {
        let target: PINAPIs = .set_card_pin(parameters: request.dictionary ?? [:])
        return networkManager
            .SystemPINRequest(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func update_card_pin(request: UpdateCardPINRequest) -> AnyPublisher<ChangePINBaseResponse<UpdateCardPINResponse>, NetworkError> {
        let target: PINAPIs = .update_card_pin(parameters: request.dictionary ?? [:])
        return networkManager
            .SystemPINRequest(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func get_mini_statement(request: GetMiniStatementRequest) -> AnyPublisher<ChangePINBaseResponse<UpdateCardPINResponse>, NetworkError> {
        let target: PINAPIs = .mini_statement(parameters: request.dictionary ?? [:])
        return networkManager
            .SystemPINRequest(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
