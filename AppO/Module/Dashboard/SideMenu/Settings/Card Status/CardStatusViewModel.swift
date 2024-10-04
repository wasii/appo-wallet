//
//  CardStatusViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum CardStatusViewModelState {
    case none
}

class CardStatusViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<CardStatusViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<CardStatusViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    @Published var cards: [Card]? = nil
    @Published var selected_card: Card?
    @Published var currentWallet: WalletCardType?
    
    var cardRefNum: String = ""
    
    private var sInteractor: SideMenuInteractorType
    
    init(sInteractor: SideMenuInteractorType = SideMenuInteractor()) {
        self.sInteractor = sInteractor
        self.cards = AppDefaults.user?.cardList
        populateCards(cardType: .appo)
        selectFirstWallet()
    }
}

extension CardStatusViewModel {
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
            let contains = AppDefaults.user?.cardList?.contains { $0.subproductName == "APPOPAY WALLET" && $0.cardStatusDesc != "InActive" } ?? false
            if contains {
                populateCards(cardType: cardType)
                selected_card = AppDefaults.user?.cardList?.filter { $0.subproductName == "APPOPAY WALLET" }.first
            }
            return contains
        case .unionpay:
            let contains = AppDefaults.user?.cardList?.contains { $0.subproductName == "UPI WALLET" && $0.cardStatusDesc != "InActive" } ?? false
            if contains {
                populateCards(cardType: cardType)
                selected_card = AppDefaults.user?.cardList?.filter { $0.subproductName == "UPI WALLET" }.first
            }
            return contains
        case .visa:
            let contains = AppDefaults.user?.cardList?.contains { $0.subproductName == "VISA WALLET" && $0.cardStatusDesc != "InActive" } ?? false
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
            selected_card = AppDefaults.user?.cardList?.filter { $0.subproductName == "APPOPAY WALLET" }.first
        case "UPI WALLET":
            self.currentWallet = .unionpay
            selected_card = AppDefaults.user?.cardList?.filter { $0.subproductName == "UPI WALLET" }.first
        case "VISA WALLET":
            self.currentWallet = .visa
            selected_card = AppDefaults.user?.cardList?.filter { $0.subproductName == "VISA WALLET" }.first
        default:
            break
        }
    }
}


extension CardStatusViewModel {
    func changeCardStatus(cardStatus: String)  async throws {
        DispatchQueue.main.async {
            self.showLoader = true
        }
        let request: ChangeCardStatusRequest = .init(
            reqHeaderInfo: .init(),
            deviceInfo: .init(
                name: "iPhone 16 Pro Max",
                manufacturer: "Apple",
                model: "A3603",
                version: "18",
                os: "iOS"
            ),
            requestKey: .init(
                requestType: "mobile_app_set_card_status"
            ),
            requestData: .init(
                instId: AppDefaults.user?.instID ?? "",
                cardRefNum: selected_card?.cardRefNum ?? "",
                cardStatus: cardStatus,
                mobileNo: AppDefaults.mobile ?? ""
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            sInteractor.change_card_status(request: request)
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
                        self?.isPresentAlert = true
                        self?.apiError = response.respInfo?.respData?.status ?? ""
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
