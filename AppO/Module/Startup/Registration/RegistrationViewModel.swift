//
//  RegistrationViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 19/08/2024.
//

import Foundation
import Combine

enum RegistrationViewModelState {
    case registered
}

class RegistrationViewModel: ObservableObject {
    var countryFlag: String
    var countryCode: String
    var phoneNumber: String
    var countryName: String
    
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<RegistrationViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<RegistrationViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    private var rInteractor: RegistrationInteractorType
    private var dInteractor: DeviceBindingInteractorType
    
    init(rInteractor: RegistrationInteractorType = RegistrationInteractor(), dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor(), countryFlag: String, countryCode: String, phoneNumber: String, countryName: String) {
        self.rInteractor = rInteractor
        self.dInteractor = dInteractor
        self.countryFlag = countryFlag
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.countryName = countryName
    }
}

extension RegistrationViewModel {
    func getUserRegistered(custName: String, mobile: String, nameOnCard: String, email: String, address: String, dob: String, nationalId: String, maritalStatus: String) async throws -> Bool {        let request: RegisterRequest = .init(
            reqHeaderInfo: .init(),
            deviceInfo: .init(
                name: "iPhone 16 Pro Max",
                manufacturer: "Apple",
                model: "A3603",
                version: "18",
                os: "iOS"
            ),
            requestKey: .init(
                requestType: "mobile_app_cust_register"
            ),
            requestData: .init(
                instID: "AP",
                custName: custName,
                mobile: mobile,
                nameOnCard: nameOnCard,
                email: email,
                address: address,
                dob: dob,
                nationalID: nationalId,
                maritalStatus: maritalStatus,
                bin: "636782",
                subproductID: "002",
                deviceNo: "12345"
            )
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            rInteractor.userRegistration(request: request)
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    if response.respInfo?.respStatus == 200 {
                        AppDefaults.newUser = response.respInfo?.respData
                        AppDefaults.mobile = mobile
                        continuation.resume(returning: (true))
                    } else {
                        self?.isPresentAlert = true
                        self?.apiError = "Something went wrong!"
                        continuation.resume(returning: (false))
                    }
                }
                .store(in: &cancellables)
        }
    }

    
    func getDMK() async throws -> Bool {
        let request: DataMasterKeyRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "cms_mapp_get_dmk"),
            requestData: .init(
                instId: "AP",
                mobileNum: AppDefaults.mobile ?? ""
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            dInteractor.getDataMasterKey(request: request)
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    continuation.resume(throwing: error)
                } receiveValue: { response in
                    if response.respInfo?.respStatus == 200 {
                        AppDefaults.dmk = response.respInfo?.respData?.dmk
                        AppDefaults.dmk_kcv = response.respInfo?.respData?.dmkKcv
                        continuation.resume(returning: (true))
                    } else {
                        continuation.resume(returning: (false))
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func validateCustomer(name: String, origin: String, id: String, identityType: String, identityNumber: String, phoneNumber: String) async throws -> Bool {
        let request: CustomerValidationRequest = .init(
            name: name,
            countryOfOrigin: origin,
            politicallyExposedPerson: true,
            id: id,
            identityType: identityType,
            identityNumber: identityNumber,
            phoneNumber: phoneNumber
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            rInteractor.customer_validation(request: request)
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    if response.signupAllowed {
                        self?.coordinatorStatePublisher.send(.with(.registered))
                        continuation.resume(returning: (true))
                    } else {
                        continuation.resume(returning: (false))
                    }
                }
                .store(in: &cancellables)
        }
    }
}

