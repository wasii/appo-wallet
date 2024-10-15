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
    var countryShortName: String = ""
    
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<RegistrationViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<RegistrationViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    var card_list: [GetCardListResponse]?
    
    private var rInteractor: RegistrationInteractorType
    private var dInteractor: DeviceBindingInteractorType
    private var sInteractor: SettingsInteractorType
    
    init(rInteractor: RegistrationInteractorType = RegistrationInteractor(), dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor(), sInteractor: SettingsInteractorType = SettingsInteractor(), countryFlag: String, countryCode: String, phoneNumber: String, countryName: String) {
        self.rInteractor = rInteractor
        self.dInteractor = dInteractor
        self.sInteractor = sInteractor
        self.countryFlag = countryFlag
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.countryName = countryName
        let countries: [PhoneNumberModel] = Bundle.main.decode("CountryNumbers.json")
        self.countryShortName = countries.filter({ model in
            model.name == self.countryName
        }).first?.code ?? ""
        print(phoneNumber)
    }
}

extension RegistrationViewModel {
    func getUserRegistered(custName: String, mobile: String, nameOnCard: String, email: String, address: String, dob: String, nationalId: String, maritalStatus: String, bin: String, subProductId: String) async throws -> Bool {        let request: RegisterRequest = .init(
            reqHeaderInfo: .init(),
            deviceInfo: .init(),
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
                bin: bin,
                subproductID: subProductId,
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
                        AppDefaults.countryFlag = self?.countryFlag
                        AppDefaults.countryName = self?.countryName
                        AppDefaults.countryShortName = self?.countryShortName
                        self?.coordinatorStatePublisher.send(.with(.registered))
                        continuation.resume(returning: (true))
                    } else {
                        continuation.resume(returning: (false))
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func getCardList() {
        self.showLoader = true
        let request: GetCardListRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(
                requestType: "mobile_app_card_product_type"
            ),
            requestData: .init(
                instId: "AP"
            )
        )
        sInteractor.get_card_list(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.respInfo?.respStatus == 200 {
                    self?.card_list = response.respInfo?.respData ?? nil
                    self?.addImageName()
                } else {
                    print("ERROR")
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func addImageName() {
        guard var cardList = card_list else { return }

        for i in 0..<cardList.count {
            switch cardList[i].subproductName {
            case "APPOPAY WALLET":
                cardList[i].imageName = "appo-pay-card"
            case "UPI WALLET":
                cardList[i].imageName = "appo-pay-unionpay"
            case "VISA WALLET":
                cardList[i].imageName = "appo-pay-visa"
            default:
                break
            }
        }
        let order: [String: Int] = [
            "APPOPAY WALLET": 0,
            "UPI WALLET": 1,
            "VISA WALLET": 2
        ]
        
        cardList.sort { card1, card2 in
            let card1Order = order[card1.subproductName ?? ""] ?? 3
            let card2Order = order[card2.subproductName ?? ""] ?? 3
            
            return card1Order < card2Order
        }
        
        self.card_list = cardList
    }
}

