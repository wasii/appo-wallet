//
//  PhoneNumberVerificationViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation
import Combine
import SwiftUI


enum PhoneNumberVerificationViewModelState {
    case confirm
    case rebinded
}
class PhoneNumberVerificationViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<PhoneNumberVerificationViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<PhoneNumberVerificationViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    var isBindingNewDevice: Bool
    
    private var interactor: PhoneNumberVerificationInteractorType
    private var dInteractor: DeviceBindingInteractorType
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    init(interactor: PhoneNumberVerificationInteractorType = PhoneNumberVerificationInteractor(),
         dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor(),
         bindingDevice: Bool) {
        self.interactor = interactor
        self.dInteractor = dInteractor
        self.isBindingNewDevice = bindingDevice
    }
}


extension PhoneNumberVerificationViewModel {
    func verifyPhoneNumber(mobPhoneNumber: String) async throws -> String {
        let request: PhoneNumberVerificationRequest = .init(
            reqHeaderInfo: .init(),
            deviceInfo: .init(),
            requestKey: .init(
                requestType: "mobile_app_cust_validation"
            ),
            requestData: .init(instID: "AP", mobileNum: mobPhoneNumber)
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            interactor.phoneNumberVerification(request: request)
                .receive(on: DispatchQueue.main)  // Ensure UI updates happen on the main thread
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else { return }
                    continuation.resume(throwing: error) // Propagate the error
                } receiveValue: { [weak self] response in
                    self?.showLoader = false
                    if response.respInfo?.respStatus == 200 {
                        self?.isPresentAlert = true
                        self?.apiError = response.respInfo?.respData?.status
                        continuation.resume(returning: response.respInfo?.respData?.status ?? "")
                    } else {
                        continuation.resume(returning: "Continue")
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    func sendOTP(mobPhoneNumber: String, phoneCode: String) async throws {
        let request: SendOTPRequest = .init(mobileNumber: mobPhoneNumber, hashKey: "3w0pkWn2S4N", phoneCode: "phoneCode")
        return try await withCheckedThrowingContinuation { continuation in
            interactor.sendOTP(request: request)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else { return }
                    self?.isPresentAlert = true
                    self?.apiError = error.localizedDescription
                    continuation.resume(throwing: error)
//                    self?.coordinatorStatePublisher.send(.with(.confirm))
                } receiveValue: { [weak self] response in
                    self?.showLoader = false
                    if response.status == "200" {
                        self?.coordinatorStatePublisher.send(.with(.confirm))
                        continuation.resume(returning: ())
                    } else {
                        let error = NSError(domain: "SendOTP", code: 1, userInfo: [NSLocalizedDescriptionKey: "OTP sending failed"])
                        continuation.resume(throwing: error)
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    
    func rebindDevice(mobileNo: String) {
        showLoader = true
        let deviceId = "\(UUID().uuidString)-\(mobileNo)"
        dInteractor.rebindDevice(request: .init(mobileNo: mobileNo, deviceId: deviceId))
            .sink { [weak self] completion in
                self?.showLoader = false
                self?.coordinatorStatePublisher.send(.with(.rebinded))
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.message == "ok" {
                    AppDefaults.deviceId = deviceId
                    AppDefaults.mobile = mobileNo
                    self?.coordinatorStatePublisher.send(.with(.rebinded))
                } else {
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                }
            }
            .store(in: &cancellables)
    }
}
