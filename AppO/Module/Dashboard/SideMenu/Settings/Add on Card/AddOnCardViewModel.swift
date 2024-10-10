//
//  AddOnCardViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 27/08/2024.
//

import Foundation
import Combine

enum AddOnCardViewModelState {
    case none
}

class AddOnCardViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<AddOnCardViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<AddOnCardViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    var card_list: [GetCardListResponse] = []
    @Published var currentWallet: WalletCardType? = nil
    @Published var selectedWallet: GetCardListResponse? = nil
    
    private var sInterator: SettingsInteractorType
    init(sInteractor: SettingsInteractorType = SettingsInteractor()) {
        self.sInterator = sInteractor
    }
}

extension AddOnCardViewModel {
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
        sInterator.get_card_list(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.respInfo?.respStatus == 200 {
                    self?.card_list = response.respInfo?.respData ?? []
                    self?.currentWallet = .appo
                    self?.updateSelectedType()
                } else {
                    print("ERROR")
                }
            }
            .store(in: &cancellables)
        
    }
    
    func createNewCard(handler: @escaping (Bool)->Void) {
        showLoader = true
        let request: CreateNewCardRequest = .init(
            reqHeaderInfo: .init(),
            deviceInfo: .init(
                name: "iPhone 16 Pro Max",
                manufacturer: "Apple",
                model: "A3603",
                version: "18",
                os: "iOS"
            ),
            requestKey: .init(requestType: "mobile_app_handle_cms_card_data_addon"),
            requestData: .init(
                instID: AppDefaults.user?.instID ?? "",
                custID: AppDefaults.user?.custID ?? "",
                productID: selectedWallet?.productId ?? "",
                subproductID: selectedWallet?.subproductId ?? ""
            )
        )
        sInterator.create_new_card(request: request)
            .sink { [weak self] completion in
                self?.showLoader = false
                guard case let .failure(error) = completion else { return }
            } receiveValue: { [weak self] response in
                self?.showLoader = false
                if response.respInfo?.respStatus == 200 {
                    handler(true)
                } else {
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                    handler(false)
                }
            }
            .store(in: &cancellables)
    }
    
    func updateSelectedType() {
        switch currentWallet {
        case .appo:
            selectedWallet = card_list.filter{ $0.subproductName == "APPOPAY WALLET" }.first
        case .unionpay:
            selectedWallet = card_list.filter{ $0.subproductName == "UPI WALLET" }.first
        case .visa:
            selectedWallet = card_list.filter{ $0.subproductName == "VISA WALLET" }.first
        case .none:
            break
        }
    }
}
