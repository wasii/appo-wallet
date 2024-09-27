//
//  HomeScreenViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine
import SwiftUI


enum HomeScreenViewModelState {
    case navigateToManageAccounts
    case navigateToMyQRCode
    case navigateToCardtoCard
    case navigateToPayments
    case navigateToSettings
    case logout
}
class HomeScreenViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<HomeScreenViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<HomeScreenViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    
    @Published var customer_enquiry: CustomerEnquiryResponseData?
    @Published var selected_card: Card?
    @Published var cardNumber: String = ""
    @Published var expiryDate: String = ""
    @Published var isCardNumberVisible: Bool = false
    
    @Published private var timeRemaining = 10
    @Published private var timerActive = false
    private var timerCancellable: AnyCancellable?
    
    private var hInteractor: HomeInteractorType
    private var dInteractor: DeviceBindingInteractorType
    private var oInteractor: VerifyOTPInteractorType
    
    init(hInteractor: HomeInteractorType = HomeInteractor(),
         dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor(),
         oInteractor: VerifyOTPInteractorType = VerifyOTPInteractor()) {
        self.hInteractor = hInteractor
        self.dInteractor = dInteractor
        self.oInteractor = oInteractor
    }
}

extension HomeScreenViewModel {
    func getCustpmerEnquiry() {
        self.showLoader = true
        let request: CustomerEnquiryRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "mobile_app_cust_enq"),
            requestData: .init(
                instID: "AP",
                mobile: AppDefaults.mobile ?? AppDefaults.user?.primaryMobileNum ?? "",
                deviceNo: "12345"
            )
        )
        hInteractor.customer_enquiry(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.respInfo?.respStatus == 200 {
                    AppDefaults.user = response.respInfo?.respData
                    AppDefaults.selected_card = response.respInfo?.respData?.cardList?.first
                    self?.customer_enquiry = response.respInfo?.respData
                    self?.selected_card = self?.customer_enquiry?.cardList?.first
                    self?.cardNumber = self?.formatCreditCardNumber(self?.selected_card?.maskCardNum ?? "") ?? ""
                    self?.expiryDate = self?.convertDateToMonthYear(self?.selected_card?.expDate ?? "") ?? ""
                    AppDefaults.newUser = nil
                } else {
                    print("ERROR")
                }
            }
            .store(in: &cancellables)
    }
    
    func showCardNumber() {
        self.showLoader = true
        let request: ShowCardNumberRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(
                requestType: "decrypt_cms_card_num"
            ),
            requestData: .init(
                instID: "AP",
                cardRefNum: selected_card?.cardRefNum ?? "",
                custId: AppDefaults.user?.custID ?? "",
                mobileNum: AppDefaults.user?.primaryMobileNum ?? ""
            )
        )
        hInteractor.show_card_number(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.respInfo?.respStatus == 200 {
                    self?.isCardNumberVisible = true
                    self?.cardNumber = self?.formatCreditCardNumber(response.respInfo?.respData?.dCardNum ?? "") ?? ""
                    self?.startTimer()
                }
            }
            .store(in: &cancellables)
    }
    
    
    fileprivate func formatCreditCardNumber(_ number: String) -> String {
        let trimmedString = number.replacingOccurrences(of: " ", with: "")
        var formattedString = ""
        for (index, character) in trimmedString.enumerated() {
            if index != 0 && index % 4 == 0 {
                formattedString.append(" ")
            }
            formattedString.append(character)
        }
        return formattedString
    }
    
    func startTimer() {
        timeRemaining = 10
        timerActive = true
        
        // Cancel the previous timer if any
        timerCancellable?.cancel()
        
        // Start a new timer
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timerActive = false
                    self.timerCancellable?.cancel()
                    self.performSpecificTask()
                }
            }
    }
    
    func performSpecificTask() {
        self.isCardNumberVisible = false
        self.cardNumber = self.formatCreditCardNumber(self.selected_card?.maskCardNum ?? "")
    }
    
    func convertDateToMonthYear(_ date: String) -> String? {
        guard date.count == 8 else {
            return nil
        }
        let startIndex = date.index(date.startIndex, offsetBy: 2)
        let endIndex = date.index(date.startIndex, offsetBy: 4)
        
        let month = String(date[startIndex..<endIndex])
        let year = String(date.suffix(4))
        
        
        return "\(month)/\(year)"
    }
}


extension HomeScreenViewModel {
    func getDataEncryptionKey() {
        self.showLoader = true
        let request: DataEncryptionKeyRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "cms_mapp_get_dek"),
            requestData: .init(
                instId: "AP",
                mobileNum: AppDefaults.mobile ?? ""
            )
        )
        dInteractor.getDataEncryptionKey(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.respInfo?.respStatus == 200 {
                    AppDefaults.dmk = response.respInfo?.respData?.dek
                    AppDefaults.dmk_kcv = response.respInfo?.respData?.dekKcv
                }
            }
            .store(in: &cancellables)
    }
}

extension HomeScreenViewModel {
    func setupPin(pin: String, completionHandler: @escaping(Bool) -> Void) {
        self.showLoader = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showLoader = false
            completionHandler(true)
        }
    }
}
