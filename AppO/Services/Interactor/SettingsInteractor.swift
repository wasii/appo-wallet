//
//  SettingsInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 02/10/2024.
//

import Combine
import Foundation

protocol SettingsInteractorType {
    func get_card_list(request: GetCardListRequest) -> AnyPublisher<SystemAPIBaseResponse<[GetCardListResponse]>, NetworkError>
    func create_new_card(request: CreateNewCardRequest) -> AnyPublisher<SystemAPIBaseResponse<CreateNewCardResponse>, NetworkError>
}

class SettingsInteractor: SettingsInteractorType {
    private var networkManager: NetworkManager<SettingsAPI>
    
    init(providerType: NetworkManagerProviderType<SettingsAPI> = .live) {
        networkManager = NetworkManager<SettingsAPI>(with: providerType)
    }
    func get_card_list(request: GetCardListRequest) -> AnyPublisher<SystemAPIBaseResponse<[GetCardListResponse]>, NetworkError> {
        let target: SettingsAPI = .get_card_list(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func create_new_card(request: CreateNewCardRequest) -> AnyPublisher<SystemAPIBaseResponse<CreateNewCardResponse>, NetworkError> {
        let target: SettingsAPI = .create_new_card(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
