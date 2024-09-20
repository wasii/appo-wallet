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
            reqHeaderInfo: .init(
                apiVersion: "1.1",
                title: "sem_mapp",
                deviceAddr: "192.168.0.100",
                requestID: UUID().uuidString,
                orgDate: "09202024",
                orgTime: "150300",
                echoMessage: "register_test",
                checkSum: UUID().uuidString
            ),
            digestInfo: "NA",
            deviceInfo: .init(
                name: "iPhone 16 Pro Max",
                manufacturer: "Apple",
                model: "A3603",
                version: "18",
                os: "iOS"
            ),
            requestKey: .init(
                requestType: "mobile_app_cust_register",
                requestID: "NA"
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
                deviceNo: "98765"
            )
        )
        
        interactor.userRegistration(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.data?.respInfo.respStatus == 200 {
//                    self?.coordinatorStatePublisher.send(.with(.registered))
                } else {
                    print("ERROR")
                }
                self?.coordinatorStatePublisher.send(.with(.registered))
            }
            .store(in: &cancellables)
    }
}

