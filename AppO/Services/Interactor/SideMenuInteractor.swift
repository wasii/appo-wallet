//
//  SideMenuInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 26/09/2024.
//


import Combine
import Foundation

protocol SideMenuInteractorType {
    func customer_balance_enquiry(request: CustomerBalanceEnquiryRequest) -> AnyPublisher<SystemAPIBaseResponse<CustomerBalanceEnquiryResponse>, NetworkError>    
}

class SideMenuInteractor: SideMenuInteractorType {
    
    private var networkManager: NetworkManager<SideMenuAPIs>
    
    init(providerType: NetworkManagerProviderType<SideMenuAPIs> = .live) {
        networkManager = NetworkManager<SideMenuAPIs>(with: providerType)
    }
    
    func customer_balance_enquiry(request: CustomerBalanceEnquiryRequest) -> AnyPublisher<SystemAPIBaseResponse<CustomerBalanceEnquiryResponse>, NetworkError> {
        let target: SideMenuAPIs = .balanceEnquiry(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
