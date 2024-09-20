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
    
    private var interactor: HomeInteractorType
    init(interactor: HomeInteractorType = HomeInteractor()) {
        self.interactor = interactor
    }
}

extension HomeScreenViewModel {
    func getCustpmerEnquiry() {
        let request: CustomerEnquiryRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "mobile_app_cust_enq"),
            requestData: .init(
                instID: "AP",
                mobile: AppDefaults.mobile ?? AppDefaults.user?.primaryMobileNum ?? "",
                deviceNo: "12345"
            )
        )
        interactor.customer_enquiry(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.respInfo?.respStatus == 200 {
                    AppDefaults.user = response.respInfo?.respData
                    self?.customer_enquiry = response.respInfo?.respData
                    self?.selected_card = self?.customer_enquiry?.cardList?.first
                    
                    AppDefaults.newUser = nil
                } else {
                    print("ERROR")
                }
            }
            .store(in: &cancellables)
    }
    
    func showCardNumber() {
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
    }
}
