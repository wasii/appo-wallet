//
//  SettingsView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBarView(title: "Settings")
                .padding(.bottom, 20)
            
            VStack {
                ForEach(SettingsRowType.allCases, id: \.self){ row in
                    Button {
                        self.navigate(index: row.rawValue)
                    } label: {
                        VStack(alignment: .leading){
                            HStack {
                                HStack {
                                    Spacer()
                                    Image(row.iconName)
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.appBlueForeground)
                                .cornerRadius(20, corners: [.topRight, .bottomRight])
                                .frame(width: 105, height: 55)
                                
                                Text(row.title)
                                    .foregroundColor(.appBlue)
                                    .font(AppFonts.bodyTwentyBold)
                                Spacer()
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func navigate(index: Int) {
        switch index {
        case 0:
            homeNavigator.navigate(to: .cardStatus(viewModel: .init()))
        case 1:
            homeNavigator.navigate(to: .changeTransactionPin(viewModel: .init()))
        case 2:
            homeNavigator.navigate(to: .replaceCard(viewModel: .init()))
        case 3:
            homeNavigator.navigate(to: .replaceCard(viewModel: .init()))
        case 4:
            homeNavigator.navigate(to: .cardSettings(viewModel: .init()))
        case 5:
            homeNavigator.navigate(to: .addOnCard(viewModel: .init()))
            
        default: break
        }
    }
}

#Preview {
    SettingsView(viewModel: .init())
}


enum SettingsRowType: Int, CaseIterable{
    case setCardStatus = 0
    case changeTransactionPin
    case replaceCard
    case renewCard
    case cardSettings
    case addOnCard
    
    var title: String{
        switch self {
        case .setCardStatus:
            return "Set Card Status"
        case .changeTransactionPin:
            return "Change Transaction Pin"
        case .replaceCard:
            return "Replace Card"
        case .renewCard:
            return "Renew Card"
        case .cardSettings:
            return "Card Settings"
        case .addOnCard:
            return "Add on Card"
        }
    }
    
    var iconName: String{
        switch self {
        case .setCardStatus:
            return "set-card-status-icon"
        case .changeTransactionPin:
            return "change-transaction-pin-icon"
        case .replaceCard:
            return "replace-card-icon"
        case .renewCard:
            return "renew-card-icon"
        case .cardSettings:
            return "card-settings-icon"
        case .addOnCard:
            return "add-on-card-icon"
        }
    }
}
