//
//  MainTabbedView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct MainTabbedView: View {
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    @StateObject var viewModel: HomeScreenViewModel = HomeScreenViewModel()
    
    var body: some View {
        ZStack{
            
            HomeScreenView(homeNavigator: .init(), presentSideMenu: $presentSideMenu, viewModel: viewModel)
                .tag(0)
            
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu) { state in
                switch state {
                case .manageAccount:
                    viewModel.coordinatorStatePublisher.send(.with(.navigateToManageAccounts))
                case .myQrCode:
                    viewModel.coordinatorStatePublisher.send(.with(.navigateToMyQRCode))
                case .cardToCard:
                    viewModel.coordinatorStatePublisher.send(.with(.navigateToCardtoCard))
                case .settings:
                    viewModel.coordinatorStatePublisher.send(.with(.navigateToSettings))
                case .changeLanguage:
                    break
                case .logout:
                    viewModel.coordinatorStatePublisher.send(.with(.logout))
                }
                
            }))
        }
    }
}

#Preview {
    MainTabbedView()
}
