//
//  ChangeTransactionPinViewModel.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import Combine

enum ChangeTransactionViewModelState {
    case none
}
class ChangeTransactionPinViewModel: ObservableObject {
    let coordinatorStatePublisher = PassthroughSubject<CoordinatorState<ChangeTransactionViewModelState>, Never>()
    var coordinatorState: AnyPublisher<CoordinatorState<ChangeTransactionViewModelState>, Never> {
        coordinatorStatePublisher.eraseToAnyPublisher()
    }
    
    private var cancellables: [AnyCancellable] = []
    
    @Published var showLoader: Bool = false
    @Published var apiError: String?
    @Published var isPresentAlert: Bool = false
    
    @Published var cards: [Card]? = nil
    @Published var selected_card: Card?
    @Published var currentWallet: WalletCardType?
    
    private var hInteractor: HomeInteractorType
    private var pInteractor: PINInteractorType
    private var dInteractor: DeviceBindingInteractorType
    
    var unmaskedCardNumber: String = ""
    
    init(hInteractor: HomeInteractorType = HomeInteractor(),
         pInteractor: PINInteractorType = PINInteractor(),
         dInteractor: DeviceBindingInteractorType = DeviceBindingInteractor()) {
        self.hInteractor = hInteractor
        self.pInteractor = pInteractor
        self.dInteractor = dInteractor
        
        self.cards = AppDefaults.user?.cardList
        populateCards(cardType: .appo)
        selectFirstWallet()
    }
}

extension ChangeTransactionPinViewModel {
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
                selected_card = AppDefaults.user?.cardList?.filter { $0.subproductName == "APPOPAY WALLET" }.first
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

extension ChangeTransactionPinViewModel {
    func getDataEncryptionKey() async throws -> Bool {
        DispatchQueue.main.async {
            self.showLoader = true
        }
        let request: DataEncryptionKeyRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(requestType: "cms_mapp_get_dek"),
            requestData: .init(
                instId: "AP",
                mobileNum: AppDefaults.mobile ?? ""
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            dInteractor.getDataEncryptionKey(request: request)
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else { return }
                    continuation.resume(throwing: error)
                } receiveValue: { response in
                    if response.respInfo?.respStatus == 200 {
                        AppDefaults.dek = response.respInfo?.respData?.dek
                        AppDefaults.dek_kcv = response.respInfo?.respData?.dekKcv
                        continuation.resume(returning: (true))
                    } else {
                        continuation.resume(returning: (false))
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func getCardNumber(cardRefNum: String) async throws -> Bool {
        let request: ShowCardNumberRequest = .init(
            reqHeaderInfo: .init(),
            requestKey: .init(
                requestType: "decrypt_cms_card_num"
            ),
            requestData: .init(
                instID: AppDefaults.user?.instID ?? "AP",
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
    
    func setCardPin(oldPin: String, newPin: String) async throws -> Bool  {
        let request: UpdateCardPINRequest = .init(
            reqHeaderInfo: .init(),
            deviceInfo: .init(),
            requestKey: .init(
                requestType: "mapp_pin_chg"
            ),
            requestData: .init(
                isoReqData: .init(
                    fld11: "001118",
                    fld12: "163756",
                    fld13: "0817",
                    fld14: "2708",
                    fld18: "0601",
                    fld19: "356",
                    fld2: self.unmaskedCardNumber,
                    fld22: "510",
                    fld3: "940000",
                    fld37: "422917001118",
                    fld41: "T0V0S101",
                    fld42: AppDefaults.user?.custID ?? "",
                    fld43: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                    fld44: AppDefaults.mobile ?? "",
                    fld49: "356",
                    fld51: "356",
                    fld52: oldPin,
                    fld53: newPin,
                    mti: "0100"
                )
            )
        )
        return try await withCheckedThrowingContinuation { continuation in
            pInteractor.update_card_pin(request: request)
                .sink { [weak self] completion in
                    self?.showLoader = false
                    guard case let .failure(error) = completion else { return }
                    self?.isPresentAlert = true
                    self?.apiError = "Invalid OTP!"
                    continuation.resume(throwing: error)
                } receiveValue: { [weak self] response in
                    if response.respInfo?.respStatus == 200 {
                        self?.isPresentAlert = true
                        self?.apiError = "Card PIN changed successfully"
                        continuation.resume(returning: (true))
                    } else if response.respInfo?.respStatus == 500 {
                        self?.isPresentAlert = true
                        self?.apiError = response.respInfo?.respDesc
                        continuation.resume(returning: (false))
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
