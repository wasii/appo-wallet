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
    @State private var nameOnCard: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    
    
    @State private var currentWallet: WalletCardType = .appo

    var walletTypes: [WalletCardType] {
        WalletCardType.allCases
    }
    
    @State private var withdrawLimit: Double = 0
    @State private var transactionLimit: Double = 0
    @State private var domesticWithdrawal: Bool = false
    @State private var domesticPurchase: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Transaction Settings")
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    WalletTypeView
                    CardView
                    mobileNumberView
                    
                    WithdrawLimitView(withdrawLimit: $withdrawLimit, title: "Withdrawal Limit")
                    
                    Rectangle()
                        .fill(.appBlue)
                        .frame(height: 0.3)
                        .padding(.vertical, 9)
                        
                    
                    WithdrawLimitView(withdrawLimit: $transactionLimit, title: "Transaction Limit")
                    
                    ToggleButtonView
                    
                    
                    Button {} label: {
                        Text("Submit")
                            .customButtonStyle()
                    }
                    .padding(.vertical, 20)
                }
                .padding(.horizontal)
            }
            BottomNavigation()
        }
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension TransactionSettingsView {
    var WalletTypeView: some View {
        HStack {
            Spacer()
            ForEach(walletTypes, id: \.self) { wallet in
                HStack {
                    Text(wallet.title)
                }
                .foregroundStyle(currentWallet == wallet ? .white : .appBlue)
                .padding()
                .frame(height: 40)
                .background(currentWallet == wallet ? .appBlue : .gray.opacity(0.08))
                .cornerRadius(60)
                .onTapGesture {
                    withAnimation {
                        currentWallet = wallet
                    }
                }
                Spacer()
            }
        }
    }
    
    var CardView: some View {
        ZStack {
            Image(currentWallet.imageName)
                .resizable()
                .frame(height: 220)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
            
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
    
    
    var mobileNumberView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Mobile Number")
                .font(AppFonts.regularTwentyTwo)
            HStack {
                Text("IN")
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.black)
                Text("+91")
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.black)
                
                Image(systemName: "chevron.down")
                    .padding(.trailing, 5)
                    .foregroundStyle(Color.black)
                    .font(AppFonts.bodyEighteenBold)
                
                Text("912356948")
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.appBlue)
                    .offset(x: 20)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(10, corners: .allCorners)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.appBlueForeground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBlue, lineWidth: 1)
            )
        }
    }
    
    var ToggleButtonView: some View {
        VStack {
            HStack {
                Text("Domestic Withdrawal")
                    .font(AppFonts.regularSixteen)
                Spacer()
                Toggle("", isOn: $domesticWithdrawal)
                    .labelsHidden()
                    .toggleStyle(CustomToggleStyle())
            }
            
            HStack {
                Text("Domestic Purchase")
                    .font(AppFonts.regularSixteen)
                Spacer()
                Toggle("", isOn: $domesticPurchase)
                    .labelsHidden()
                    .toggleStyle(CustomToggleStyle())
            }
        }
        .foregroundStyle(.appBlue)
        .padding(.top, 30)
        .frame(width: 300)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    TransactionSettingsView(viewModel: .init())
}
