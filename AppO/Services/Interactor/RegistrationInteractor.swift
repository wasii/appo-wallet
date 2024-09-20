//
//  RegistrationInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation
import Alamofire
import Combine

protocol RegistrationInteractorType {
    func userRegistration(request: RegisterRequest) -> AnyPublisher<APIBaseResponse<RegistrationResponse>, NetworkError>
}

final class RegistrationInteractor: RegistrationInteractorType {

    private var networkManager: NetworkManager<RegistrationAPIs>

    init(providerType: NetworkManagerProviderType<RegistrationAPIs> = .live) {
        networkManager = NetworkManager<RegistrationAPIs>(with: providerType)
    }

    func userRegistration(request: RegisterRequest) -> AnyPublisher<APIBaseResponse<RegistrationResponse>, NetworkError> {
        let target: RegistrationAPIs = .registration(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
