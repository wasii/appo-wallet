//
//  RegistrationInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation
import Alamofire
import Combine

protocol RegistrationProtocol {
    func userRegistration(request: RegistrationRequest) -> AnyPublisher<APIBaseResponse<RegistrationResponse>, NetworkError>
}

final class RegistrationInteractor: RegistrationProtocol {

    private var networkManager: NetworkManager<RegistrationAPIs>

    init(providerType: NetworkManagerProviderType<RegistrationAPIs> = .live) {
        networkManager = NetworkManager<RegistrationAPIs>(with: providerType)
    }

    func userRegistration(request: RegistrationRequest) -> AnyPublisher<APIBaseResponse<RegistrationResponse>, NetworkError> {
        let target: RegistrationAPIs = .registration(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
