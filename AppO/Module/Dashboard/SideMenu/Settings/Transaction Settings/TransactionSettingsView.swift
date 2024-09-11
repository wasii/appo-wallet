//
//  TransactionSettingsView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct TransactionSettingsView: View {
    
    @StateObject var viewModel: TransactionSettingsViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    @State private var phoneNumber: String = ""
    @State private var domesticWithdrawal: String = ""
    @State private var domesticPurchase: String = ""
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Transaction Settings")
            CardButtonView(cardType: "Visa Gold Card", cardNumber: "423671******0129" ,cardExpiry: "01/30")
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Mobile Number")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.gray)
                HStack {
                    HStack {
                        Text("Panama")
                            .font(.subheadline)
                            .padding(.leading, 5)
                        Text("+507")
                            .font(.subheadline)
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                    .frame(width: 120, height: 57)
                    .background(Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    
                    TextField("Enter your phone number", text: $phoneNumber)
                        .customTextfieldStyle()
                }
            }
            
            HStack {
                Text("Domestic Withdrawal")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.gray)
                Spacer()
                RadioButtonField(id: "on", label: "No", isSelected: domesticWithdrawal == "no") {
                    domesticWithdrawal = "no"
                }
                RadioButtonField(id: "off", label: "Off", isSelected: domesticWithdrawal == "off") {
                    domesticWithdrawal = "off"
                }
            }
            .customTextfieldStyle()
            
            HStack {
                Text("Domestic Purchase")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.gray)
                Spacer()
                RadioButtonField(id: "on", label: "No", isSelected: domesticPurchase == "no") {
                    domesticPurchase = "no"
                }
                RadioButtonField(id: "off", label: "Off", isSelected: domesticPurchase == "off") {
                    domesticPurchase = "off"
                }
            }
            .customTextfieldStyle()
            
            Spacer()
            
            Button {} label: {
                Text("Submit")
                    .customButtonStyle()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    TransactionSettingsView(viewModel: .init())
}
