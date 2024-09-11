//
//  HomeScreenView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

enum WalletCardType: CaseIterable {
    case appo
    case unionpay
    case visa
    
    var imageName: String {
        switch self {
        case .appo:
            return "appo-pay-card"
        case .unionpay:
            return "appopay-unionpay-card-visible"
        case .visa:
            return "appopay-visa-card"
        }
    }
    
    var title: String {
        switch self {
        case .appo:
            return "AppO"
        case .unionpay:
            return "Union Pay"
        case .visa:
            return "Visa"
        }
    }
}

struct HomeScreenView: View {
    @StateObject var homeNavigator: HomeNavigator
    @Binding var presentSideMenu: Bool
    
    @StateObject var viewModel: HomeScreenViewModel
    
    @State private var currentWallet: WalletCardType = .appo

    var walletTypes: [WalletCardType] {
        WalletCardType.allCases
    }
    
    var body: some View {
        NavigationStack(path: $homeNavigator.navPath) {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.appBlue)
                        .frame(height: 100)
                        .cornerRadius(40, corners: [.bottomLeft, .bottomRight])
                    HStack(spacing: 20) {
                        Button(action: {
                            presentSideMenu.toggle()
                        }) {
                            Image("sidebar-menu")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        }
                        Text("🇮🇳 India (IN)")
                            .foregroundColor(.white)
                            .font(AppFonts.headline4)
                            .bold()
                        Spacer()
                    }
                    .padding()
                }
                
                ScrollView {
                    VStack(alignment: .center, spacing: 15) {
                        WalletTypeView
                        CardStatusView
                        CardView
                        
                        Text("Services")
                            .font(AppFonts.regular3)
                            .foregroundStyle(.appBlue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ServicesButtons
                    }
                    .padding()
                }
                BottomNavigation()
            }
            .edgesIgnoringSafeArea(.top)
            .toolbar(.hidden, for: .navigationBar)
            .onReceive(viewModel.coordinatorState) { state in
                switch (state.state, state.transferable) {
                case (.navigateToManageAccounts, _):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        homeNavigator.navigate(to: .manageAccounts(viewModel: .init()))
                    }
                case (.navigateToMyQRCode, _):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        homeNavigator.navigate(to: .myQR(viewModel: .init()))
                    }
                case (.navigateToCardtoCard, _):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        homeNavigator.navigate(to: .cardToCard(viewModel: .init()))
                    }
                case (.navigateToPayments, _):
                    break
                case (.navigateToSettings, _):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        homeNavigator.navigate(to: .settings(viewModel: .init()))
                    }
                }
            }
            .navigationDestination(for: HomeNavigator.Destination.self) { destination in
                homeNavigator.view(for: destination)
            }
        }
        .environmentObject(homeNavigator)
    }
}

#Preview {
    HomeScreenView(homeNavigator: .init(), presentSideMenu: .constant(true), viewModel: .init())
}

extension HomeScreenView {
    var WalletTypeView: some View {
        HStack {
            Spacer()
            ForEach(walletTypes, id: \.self) { wallet in
                HStack {
                    Text(wallet.title)
                }
                .foregroundStyle(currentWallet == wallet ? .white : .appBlue)
                .padding()
                .background(currentWallet == wallet ? .appBlue : .gray.opacity(0.08))
                .cornerRadius(20)
                .onTapGesture {
                    withAnimation {
                        currentWallet = wallet
                    }
                }
                Spacer()
            }
        }
    }

    
    var CardStatusView: some View {
        HStack {
            Text("Card Status: ")
                .font(AppFonts.regularEighteen)
            + Text("InActive")
                .font(AppFonts.bodyEighteenBold)
        }
        .foregroundStyle(.appBlue)
    }
    
    var CardView: some View {
        ZStack {
            Image(currentWallet.imageName)
                .resizable()
                .frame(height: 220)
            
            VStack(alignment: .leading) {
                Spacer()
                Text("6262 2303 5678 9010")
                    .font(AppFonts.regularTwenty)
                Text("Expiry: 10/2016 JOE CHURCO")
                    .font(AppFonts.bodyFourteenBold)
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var ServicesButtons: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 15) {
                VStack {
                    Image("recharge-icon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.appBlueForeground))
                    Text("Recharge")
                        .foregroundColor(.appBlue)
                        .font(.headline)
                }
                VStack {
                    Image("nfc-icon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.appBlueForeground))
                    Text("NFC")
                        .foregroundColor(.appBlue)
                        .font(.headline)
                }
                VStack {
                    Image("scan-icon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.appBlueForeground))
                    Text("Scan")
                        .foregroundColor(.appBlue)
                        .font(.headline)
                }
                VStack {
                    Image("c-2-c-icon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Circle().fill(Color.appBlueForeground))
                    Text("C-2-C")
                        .foregroundColor(.appBlue)
                        .font(.headline)
                }
            }
        }
    }
}


struct WalletTypes: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
}
