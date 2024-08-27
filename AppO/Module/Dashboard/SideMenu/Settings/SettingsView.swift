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
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Settings")
                .padding(.bottom, 20)
            
            ForEach(SettingsRowType.allCases, id: \.self){ row in
                Button {
                    self.navigate(index: row.rawValue)
                } label: {
                    VStack(alignment: .leading){
                        HStack(spacing: 20){
                            ZStack{
                                Circle()
                                    .fill(Color.appYellow)
                                    .frame(width: 50, height: 50)
                                Image(systemName: row.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 40, height: 40)
                            Text(row.title)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.black.opacity(0.7))
                            Spacer()
                        }
                        .padding(.leading, 5)
                        
                        Divider()
                    }
                }
            }
            Spacer()
        }
        .padding()
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
            return "creditcard"
        case .changeTransactionPin:
            return "creditcard"
        case .replaceCard:
            return "creditcard"
        case .renewCard:
            return "creditcard"
        case .cardSettings:
            return "creditcard"
        case .addOnCard:
            return "creditcard"
        }
    }
}
