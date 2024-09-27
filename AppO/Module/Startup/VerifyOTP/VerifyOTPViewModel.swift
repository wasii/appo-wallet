//
//  VerifyOTPViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation
import Combine

enum VerifyOTPViewModelState {
    case verify
}

class VerifyOTPViewModel: ObservableObject {
    var countryCode: String
    var phoneNumber: String
    var countryFlag: String
    
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<VerifyOTPViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<VerifyOTPViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    private var interactor: VerifyOTPInteractorType
    private var dInteractor: DeviceBindingInteractorType
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    init(interactor: VerifyOTPInteractorType = VerifyOTPInteractor(), dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor(), countryCode: String, phoneNumber: String, countryFlag: String) {
        self.interactor = interactor
        self.dInteractor = dInteractor
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.countryFlag = countryFlag
    }
}


extension VerifyOTPViewModel {
    func verifyOtp(otp: String) {
        showLoader = true
        interactor.verifyOTP(number: self.phoneNumber, otp: otp)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                if response.status == "200" {
                    self?.bindDevice()
                }
                else {
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindDevice() {
        let deviceId = "\(UUID().uuidString)-\(self.phoneNumber)"
        dInteractor.bindDevice(request: .init(mobileNo: self.phoneNumber, deviceId: deviceId))
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                if response.message == "ok" {
                    AppDefaults.deviceId = deviceId
                    AppDefaults.mobile = self?.phoneNumber
                    self?.coordinatorStatePublisher.send(.with(.verify))
                }
                else {
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                }
            }
            .store(in: &cancellables)
    }
}
