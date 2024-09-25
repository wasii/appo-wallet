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
    func getDataMasterKey(request: DataMasterKeyRequest) -> AnyPublisher<SystemAPIBaseResponse<DataMasterKeyResponse>, NetworkError>
    func getDataEncryptionKey(request: DataEncryptionKeyRequest) -> AnyPublisher<SystemAPIBaseResponse<DataEncryptionKeyRequest>, NetworkError>
}

class DeviceBindingInteractor: DeviceBindingInteractorType {
    
    private var networkManager: NetworkManager<DeviceBindingAPIs>
    
    init(providerType: NetworkManagerProviderType<DeviceBindingAPIs> = .live) {
        networkManager = NetworkManager<DeviceBindingAPIs>(with: providerType)
    }
    
    func bindDevice(request: BindDeviceRequest) -> AnyPublisher<BindDeviceResponse, NetworkError> {
        let target: DeviceBindingAPIs = .bindDevice(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func rebindDevice(request: ReBindDeviceRequest) -> AnyPublisher<RebindDeviceResponse, NetworkError> {
        let target: DeviceBindingAPIs = .rebindDevice(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func getDataMasterKey(request: DataMasterKeyRequest) -> AnyPublisher<SystemAPIBaseResponse<DataMasterKeyResponse>, NetworkError> {
        let target: DeviceBindingAPIs = .getDMK(parametes: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func getDataEncryptionKey(request: DataEncryptionKeyRequest) -> AnyPublisher<SystemAPIBaseResponse<DataEncryptionKeyRequest>, NetworkError> {
        let target: DeviceBindingAPIs = .getDEK(parametes: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
