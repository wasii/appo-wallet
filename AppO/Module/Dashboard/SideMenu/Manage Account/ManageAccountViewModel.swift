//
//  ManageAccountViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import SwiftUI
import Combine

enum ManageAccountViewModelState {
    case showTransactions
}
class ManageAccountViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ManageAccountViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ManageAccountViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    
    @Published var cards: [Card]? = nil
    @Published var selected_card: Card?
    @Published var currentWallet: WalletCardType?
    
    @Published var isShowTransactionPin: Bool = false
    @Published var isShowUnMaskedCard: Bool = false
    
    var unmaskedCardNumber: String = ""
    
    private var hInteractor: HomeInteractorType
    init(hInteractor: HomeInteractorType = HomeInteractor()) {
        self.hInteractor = hInteractor
        self.cards = AppDefaults.user?.cardList
        populateCards(cardType: .appo)
        selectFirstWallet()
    }
}


extension ManageAccountViewModel {
    func populateCards(cardType: WalletCardType) {
        switch cardType {
        case .appo:
            cards = AppDefaults.user?.cardList?.filter { $0.subproductName == "APPOPAY WALLET" }
        case .unionpay:
            cards = AppDefaults.user?.cardList?.filter { $0.subproductName == "UPI WALLET" }
        case .visa:
            cards = AppDefaults.user?.cardList?.filter { $0.subproductName == "VISA WALLET" }
        }
    }
    
    func changeWalletType(cardType: WalletCardType) -> Bool {
        switch cardType {
        case .appo:
            let contains = AppDefaults.user?.cardList?.contains { $0.subproductName == "APPOPAY WALLET" } ?? false
            if contains {
                populateCards(cardType: cardType)
                selected_card = cards?.filter { $0.subproductName == "APPOPAY WALLET" }.first
            }
            return contains
        case .unionpay:
            let contains = AppDefaults.user?.cardList?.contains { $0.subproductName == "UPI WALLET" } ?? false
            if contains {
                populateCards(cardType: cardType)
                selected_card = AppDefaults.user?.cardList?.filter { $0.subproductName == "UPI WALLET" }.first
            }
            return contains
        case .visa:
            let contains = AppDefaults.user?.cardList?.contains { $0.subproductName == "VISA WALLET" } ?? false
            if contains {
                populateCards(cardType: cardType)
                selected_card = AppDefaults.user?.cardList?.filter { $0.subproductName == "VISA WALLET" }.first
            }
            return contains
        }
    }
    
    fileprivate func selectFirstWallet() {
        let subproductName = AppDefaults.user?.cardList?.first?.subproductName
        switch subproductName {
        case "APPOPAY WALLET":
            self.currentWallet = .appo
        case "UPI WALLET":
            self.currentWallet = .unionpay
        case "VISA WALLET":
            self.currentWallet = .visa
        default:
            break
        }
    }
}


extension ManageAccountViewModel {
    func getCardNumber(cardRefNum: String) async throws -> Bool {
        let request: ShowCardNumberRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(
                requestType: "decrypt_cms_card_num"
            ),
            requestData: .init(
                instID: "AP",
                cardRefNum: cardRefNum,
                custId: AppDefaults.user?.custID ?? "",
                mobileNum: AppDefaults.user?.primaryMobileNum ?? ""
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            hInteractor.show_card_number(request: request)
                .sink { [weak self] completion in
                    guard case let .failure(error) = completion else { return }
                    self?.isPresentAlert = true
                    self?.apiError = "Something went wrong!"
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    if response.respInfo?.respStatus == 200 {
                        self?.unmaskedCardNumber = response.respInfo?.respData?.dCardNum ?? ""
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
}
