//
//  SetupMobilePinInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation
import Combine

protocol SetupMobilePinInteractorType {
    func savePIN(request: SetupMobilePinRequest) -> AnyPublisher<SetupMobilePinResponse, NetworkError>
}

class SetupMobilePinInteractor: SetupMobilePinInteractorType {
    
    private var networkManager: NetworkManager<OTPAPIs>
    
    init(providerType: NetworkManagerProviderType<OTPAPIs> = .live) {
        networkManager = NetworkManager<OTPAPIs>(with: providerType)
    }
    
    func savePIN(request: SetupMobilePinRequest) -> AnyPublisher<SetupMobilePinResponse, NetworkError> {
        let target: OTPAPIs = .savePIN(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
