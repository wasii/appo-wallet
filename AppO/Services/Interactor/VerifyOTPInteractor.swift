//
//  VerifyOTPInteractor.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation
import Combine

protocol VerifyOTPInteractorType {
    func verifyOTP(number: String, otp:String) -> AnyPublisher<VerifyOTPResponse, NetworkError>
}

class VerifyOTPInteractor: VerifyOTPInteractorType {
    
    private var networkManager: NetworkManager<OTPAPIs>
    
    init(providerType: NetworkManagerProviderType<OTPAPIs> = .live) {
        networkManager = NetworkManager<OTPAPIs>(with: providerType)
    }
    
    func verifyOTP(number: String, otp:String) -> AnyPublisher<VerifyOTPResponse, NetworkError> {
        let target: OTPAPIs = .validateOTP(number: number, otp: otp)
        return networkManager
            .request(target: target)
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}
