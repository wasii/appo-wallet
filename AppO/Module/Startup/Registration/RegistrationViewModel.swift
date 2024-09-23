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
    
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<RegistrationViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<RegistrationViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    private var interactor: RegistrationInteractorType
    
    init(interactor: RegistrationInteractorType = RegistrationInteractor(), countryFlag: String, countryCode: String, phoneNumber: String) {
        self.interactor = interactor
        self.countryFlag = countryFlag
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
}

extension RegistrationViewModel {
    func getUserRegistered(custName: String, mobile: String, nameOnCard: String, email: String, address: String, dob: String, nationalId: String, maritalStatus: String) {
        showLoader = true
        let request: RegisterRequest = .init(
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
        
        interactor.userRegistration(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.respInfo?.respStatus == 200 {
                    AppEnvironment.shared.isLoggedIn = true
                    AppDefaults.newUser = response.respInfo?.respData
                    AppDefaults.mobile = mobile
                    self?.coordinatorStatePublisher.send(.with(.registered))
                } else {
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                }
            }
            .store(in: &cancellables)
    }
}

