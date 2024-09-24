//
//  VerifyPINInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 24/09/2024.
//

import Combine
import Foundation

protocol VerifyPINInteractorType {
    func verifyPIN(request: VerifyPINRequest) -> AnyPublisher<VerifyPINResponse, NetworkError>
    
}

class VerifyPINInteractor: VerifyPINInteractorType {
    
    private var networkManager: NetworkManager<VerifyPINAPIs>
    
    init(providerType: NetworkManagerProviderType<VerifyPINAPIs> = .live) {
        networkManager = NetworkManager<VerifyPINAPIs>(with: providerType)
    }
    
    func verifyPIN(request: VerifyPINRequest) -> AnyPublisher<VerifyPINResponse, NetworkError> {
        let target: VerifyPINAPIs = .verifyPIN(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
