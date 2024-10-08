//
//  HomeNavigator.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
import SwiftUI

final class HomeNavigator: ObservableObject {

    enum Destination: Hashable, Identifiable {
        var id: Self { self }
        func hash(into hasher: inout Hasher) {
            hasher.combine(0)
        }
        
        static func == (lhs: Destination, rhs: Destination) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        case manageAccounts(viewModel: ManageAccountViewModel)
        case myQR(viewModel: MyQRCodeViewModel)
        case cardToCard(viewModel: CardToCardViewModel)
//        case payments
        case settings(viewModel: SettingsViewModel)
        
        //Manage Accounts
        case transactionsDetails(viewModel: CardTransactionDetailsViewModel)
        
        
        //Settings
        case cardStatus(viewModel: CardStatusViewModel)
        case changeTransactionPin(viewModel: ChangeTransactionPinViewModel)
        case replaceCard(viewModel: ReplaceCardViewModel)
        case renewCard(viewModel: RenewCardViewModel)
        case cardSettings(viewModel: TransactionSettingsViewModel)
        case addOnCard(viewModel: AddOnCardViewModel)
        
        //Card List
        case cardList(viewModel: CardListViewModel)
    }
    
    @Published var navPath = NavigationPath()
    @Published var presentedSheetDestination: Destination? // For modals
    @Published var presentedFullScreenDestination: Destination? // For modals
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateBack(to index: Int) {
        navPath.removeLast(navPath.count - index)
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
    
    func presentFullScreen(destination: Destination) {
        presentedFullScreenDestination = destination
    }
    
    func presentSheet(destination: Destination) {
        presentedSheetDestination = destination
    }
    
    func dismissModal() {
        presentedSheetDestination = nil
        presentedFullScreenDestination = nil
    }
}

// MARK: - ViewBuilder
extension HomeNavigator {
    @ViewBuilder func view(for destination: HomeNavigator.Destination) -> some View {
        switch destination {
        case .manageAccounts(let viewModel):
            ManageAccountView(viewModel: viewModel)
        case .myQR(let viewModel):
            MyQRCodeView(viewModel: viewModel)
        case .cardToCard(let viewModel):
            CardToCardView(viewModel: viewModel)
//        case .payments: break
        case .settings(let viewModel):
            SettingsView(viewModel: viewModel)
            
        //Manage Accounts -> Card Transactions
        case .transactionsDetails(let viewModel):
            CardTransactionDetailsView(viewModel: viewModel)
            
        
        //Settings -> Sub Views
        case .cardStatus(let viewModel):
            CardStatusView(viewModel: viewModel)
        case .changeTransactionPin(let viewModel):
            ChangeTransactionPinView(viewModel: viewModel)
        case .replaceCard(let viewModel):
            ReplaceCardView(viewModel: viewModel)
        case .renewCard(let viewModel):
            RenewCardView(viewModel: viewModel)
        case .cardSettings(let viewModel):
            TransactionSettingsView(viewModel: viewModel)
        case .addOnCard(let viewModel):
            AddOnCardView(viewModel: viewModel)
        
        //Card List
        case .cardList(let viewModel):
            CardListView(viewModel: viewModel)
        }
    }
}
