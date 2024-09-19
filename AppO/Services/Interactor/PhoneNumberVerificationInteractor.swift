//
//  PhoneNumberVerificationInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation
import Combine


protocol PhoneNumberVerificationInteractorType {
    func sendOTP(request: SendOTPRequest) -> AnyPublisher<APIBaseResponse<SendOTPResponse>, NetworkError>
}
class PhoneNumberVerificationInteractor: PhoneNumberVerificationInteractorType {
    
    private var networkManager: NetworkManager<OTPAPIs>
    
    init(providerType: NetworkManagerProviderType<OTPAPIs> = .live) {
        networkManager = NetworkManager<OTPAPIs>(with: providerType)
    }
    
    func sendOTP(request: SendOTPRequest) -> AnyPublisher<APIBaseResponse<SendOTPResponse>, NetworkError> {
        let target: OTPAPIs = .sendOTP(parameters: request.dictionary ?? [:])
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
