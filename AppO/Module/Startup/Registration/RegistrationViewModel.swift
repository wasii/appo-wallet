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
    
    private var rInteractor: RegistrationInteractorType
    private var dInteractor: DeviceBindingInteractorType
    
    init(rInteractor: RegistrationInteractorType = RegistrationInteractor(), dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor(), countryFlag: String, countryCode: String, phoneNumber: String) {
        self.rInteractor = rInteractor
        self.dInteractor = dInteractor
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
        
        rInteractor.userRegistration(request: request)
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
    
    func getDMK(handler: @escaping(Bool) -> Void) {
        self.showLoader = true
        let request: DataMasterKeyRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "cms_mapp_get_dmk"),
            requestData: .init(
                instId: "AP",
                mobileNum: AppDefaults.mobile ?? ""
            )
        )
        dInteractor.getDataMasterKey(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
                handler(false)
            } receiveValue: { response in
                if response.respInfo?.respStatus == 200 {
                    AppDefaults.dmk = response.respInfo?.respData?.dmk
                    AppDefaults.dmk_kcv = response.respInfo?.respData?.dmkKcv
                    handler(true)
                } else {
                    handler(false)
                }
            }
            .store(in: &cancellables)

    }
}

