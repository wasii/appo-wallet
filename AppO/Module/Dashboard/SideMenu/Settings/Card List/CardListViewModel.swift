//
//  CardListViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 08/10/2024.
//

import Foundation
import Combine

enum CardListViewModelState {
    case card
}

class CardListViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<CardListViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<CardListViewModelState>, Never> {
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
    var customer_enquiry: CustomerEnquiryResponseData?
    
    private var hInteractor: HomeInteractorType
    
    @Published var showQRDetails: Bool
    
    init(hInteractor: HomeInteractorType = HomeInteractor(), showQRDetails: Bool = false) {
        self.hInteractor = hInteractor
        self.showQRDetails = showQRDetails
    }
}


extension CardListViewModel {
    func populateCards(cardType: WalletCardType) {
        switch cardType {
        case .appo:
            cards = customer_enquiry?.cardList?.filter { $0.subproductName == "APPOPAY WALLET" }
        case .unionpay:
            cards = customer_enquiry?.cardList?.filter { $0.subproductName == "UPI WALLET" }
        case .visa:
            cards = customer_enquiry?.cardList?.filter { $0.subproductName == "VISA WALLET" }
        }
    }
    
    func changeWalletType(cardType: WalletCardType) -> Bool {
        switch cardType {
        case .appo:
            let contains = customer_enquiry?.cardList?.contains { $0.subproductName == "APPOPAY WALLET" && $0.cardStatusDesc != "InActive" } ?? false
            if contains {
                populateCards(cardType: cardType)
                selected_card = customer_enquiry?.cardList?.filter { $0.subproductName == "APPOPAY WALLET" }.first
            }
            return contains
        case .unionpay:
            let contains = customer_enquiry?.cardList?.contains { $0.subproductName == "UPI WALLET" && $0.cardStatusDesc != "InActive" } ?? false
            if contains {
                populateCards(cardType: cardType)
                selected_card = customer_enquiry?.cardList?.filter { $0.subproductName == "UPI WALLET" }.first
            }
            return contains
        case .visa:
            let contains = customer_enquiry?.cardList?.contains { $0.subproductName == "VISA WALLET" && $0.cardStatusDesc != "InActive" } ?? false
            if contains {
                populateCards(cardType: cardType)
                selected_card = customer_enquiry?.cardList?.filter { $0.subproductName == "VISA WALLET" }.first
            }
            return contains
        }
    }
    
    fileprivate func selectFirstWallet() {
        let subproductName = customer_enquiry?.cardList?.first?.subproductName
        switch subproductName {
        case "APPOPAY WALLET":
            populateCards(cardType: .appo)
            self.currentWallet = .appo
            selected_card = customer_enquiry?.cardList?.filter { $0.subproductName == "APPOPAY WALLET" }.first
        case "UPI WALLET":
            populateCards(cardType: .unionpay)
            self.currentWallet = .unionpay
            selected_card = customer_enquiry?.cardList?.filter { $0.subproductName == "UPI WALLET" }.first
        case "VISA WALLET":
            populateCards(cardType: .visa)
            self.currentWallet = .visa
            selected_card = customer_enquiry?.cardList?.filter { $0.subproductName == "VISA WALLET" }.first
        default:
            break
        }
    }
}


extension CardListViewModel {
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
                    self?.customer_enquiry = response.respInfo?.respData
                    self?.populateImageName()
                    self?.selectFirstWallet()
                } else {
                    print("ERROR")
                }
            }
            .store(in: &cancellables)
    }
    
    func populateImageName() {
        guard var cardList = customer_enquiry?.cardList else { return }

        for i in 0..<cardList.count {
            switch cardList[i].subproductName {
            case "APPOPAY WALLET":
                cardList[i].cardImage = "appo-pay-card"
            case "UPI WALLET":
                cardList[i].cardImage = "appo-unionpay"
            case "VISA WALLET":
                cardList[i].cardImage = "appo-visa"
            default:
                break
            }
            cardList[i].maskCardNum = Formatters.formatCreditCardNumber(cardList[i].maskCardNum ?? "")
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

        self.customer_enquiry?.cardList = cardList
    }
}
