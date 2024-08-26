//
//  SettingsView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct SettingsView: View {
    let items = ["Item 1", "Item 2", "Item 3"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Settings")
                .padding(.bottom, 20)
            
            ForEach(SettingsRowType.allCases, id: \.self){ row in
                Button {} label: {
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
    }
}

#Preview {
    SettingsView()
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
