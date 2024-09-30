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
    func userRegistration(request: RegisterRequest) -> AnyPublisher<SystemAPIBaseResponse<RegistrationResponseData>, NetworkError>
    func customer_validation(request: CustomerValidationRequest) -> AnyPublisher<CustomerValidationResponse, NetworkError>
}

final class RegistrationInteractor: RegistrationInteractorType {

    private var networkManager: NetworkManager<RegistrationAPIs>

    init(providerType: NetworkManagerProviderType<RegistrationAPIs> = .live) {
        networkManager = NetworkManager<RegistrationAPIs>(with: providerType)
    }

    func userRegistration(request: RegisterRequest) -> AnyPublisher<SystemAPIBaseResponse<RegistrationResponseData>, NetworkError> {
        let target: RegistrationAPIs = .registration(parameters: request.dictionary ?? [:])
        return networkManager
            .systemAPIRequest(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func customer_validation(request: CustomerValidationRequest) -> AnyPublisher<CustomerValidationResponse, NetworkError> {
        let target: RegistrationAPIs = .customer_validation(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
