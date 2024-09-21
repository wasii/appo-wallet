//
//  HomeInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 20/09/2024.
//

import Foundation
import Combine

protocol HomeInteractorType {
    func customer_enquiry(request: CustomerEnquiryRequest) -> AnyPublisher<SystemAPIBaseResponse<CustomerEnquiryResponseData>, NetworkError>
    func show_card_number(request: ShowCardNumberRequest) -> AnyPublisher<SystemAPIBaseResponse<ShowCardNumberResponse>, NetworkError>
}

class HomeInteractor: HomeInteractorType {
    private var networkManager: NetworkManager<HomeAPIs>

    init(providerType: NetworkManagerProviderType<HomeAPIs> = .live) {
        networkManager = NetworkManager<HomeAPIs>(with: providerType)
    }

    //MARK: Get Customer Enquiry
    func customer_enquiry(request: CustomerEnquiryRequest) -> AnyPublisher<SystemAPIBaseResponse<CustomerEnquiryResponseData>, NetworkError> {
        let target: HomeAPIs = .customer_enquiry(parameters: request.dictionary ?? [:])
        
        return networkManager
            .systemAPIRequest(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    //MARK: Show Card Number
    func show_card_number(request: ShowCardNumberRequest) -> AnyPublisher<SystemAPIBaseResponse<ShowCardNumberResponse>, NetworkError> {
        let target: HomeAPIs = .customer_enquiry(parameters: request.dictionary ?? [:])
        
        return networkManager
            .systemAPIRequest(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
}
