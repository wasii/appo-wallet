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
    
    private var sInteractor: SideMenuInteractorType
    
    init(sInteractor: SideMenuInteractorType = SideMenuInteractor()) {
        self.sInteractor = sInteractor
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
                instId: "AP",
                cardRefNum: AppDefaults.selected_card?.cardRefNum ?? "",
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
