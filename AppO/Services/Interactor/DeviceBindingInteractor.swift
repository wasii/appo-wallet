//
//  DeviceBindingInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 24/09/2024.
//

import Combine
import Foundation

protocol DeviceBindingInteractorType {
    func bindDevice(request: BindDeviceRequest) -> AnyPublisher<BindDeviceResponse, NetworkError>
    func rebindDevice(request: ReBindDeviceRequest) -> AnyPublisher<RebindDeviceResponse, NetworkError>
}

class DeviceBindingInteractor: DeviceBindingInteractorType {
    
    private var networkManager: NetworkManager<OTPAPIs>
    
    init(providerType: NetworkManagerProviderType<OTPAPIs> = .live) {
        networkManager = NetworkManager<OTPAPIs>(with: providerType)
    }
    
    func bindDevice(request: BindDeviceRequest) -> AnyPublisher<BindDeviceResponse, NetworkError> {
        let target: OTPAPIs = .bindDevice(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func rebindDevice(request: ReBindDeviceRequest) -> AnyPublisher<RebindDeviceResponse, NetworkError> {
        let target: OTPAPIs = .rebindDevice(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
