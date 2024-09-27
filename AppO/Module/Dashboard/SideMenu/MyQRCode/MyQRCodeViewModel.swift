//
//  MyQRCodeViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import SwiftUI
import Combine

enum MyQRCodeViewModelState {
    case showBalance
}
class MyQRCodeViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<MyQRCodeViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<MyQRCodeViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    @Published var userBalance: String = ""
    @Published var isShowPopup: Bool = false
    @Published var isShow: Bool = false
    
    private var sInteractor: SideMenuInteractorType
    init(sInteractor: SideMenuInteractorType = SideMenuInteractor()) {
        self.sInteractor = sInteractor
    }
}

extension MyQRCodeViewModel {
    func getCustomerAvailableBalance()  async throws {
        DispatchQueue.main.async {
            self.showLoader = true
        }
        let request: CustomerBalanceEnquiryRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(
                requestType: "mobile_app_cust_bal_enq"
            ),
            requestData: .init(
                instId: "AP",
                cardRefNum: AppDefaults.selected_card?.cardRefNum ?? "",
                mobile: AppDefaults.mobile ?? "",
                deviceNo: AppDefaults.deviceId ?? ""
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            sInteractor.customer_balance_enquiry(request: request)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else {
                        return
                    }
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    self?.showLoader = false
                    if response.respInfo?.respStatus == 200 {
                        self?.userBalance = response.respInfo?.respData?.availBal ?? ""
                        self?.isShow = true
                        continuation.resume(returning: ())
                    } else {
                        self?.isPresentAlert = true
                        self?.apiError = "Something went wrong!"
                        continuation.resume(returning: ())
                    }
                }
                .store(in: &self.cancellables)
        }
        
    }
}
