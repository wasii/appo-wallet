//
//  CardStatusView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct CardStatusView: View {
    @State private var cardStatus: String = ""
    @StateObject var viewModel: CardStatusViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    @State private var isActive: Bool = true
    @State private var isBlock:  Bool = true
    
    @State private var currentWallet: WalletCardType = .visa
    var walletTypes: [WalletCardType] {
        WalletCardType.allCases
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Card Status")
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    WalletTypeView
                    CardView
                    
                    Text("You can set below Status of the Card")
                        .font(AppFonts.bodyEighteenBold)
                        .foregroundStyle(.appBlue)
                        .padding(.bottom, 30)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Active")
                            Toggle("", isOn: $isActive)
                                .toggleStyle(CustomToggleStyle())
                                .labelsHidden()
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Block")
                            Toggle("", isOn: $isBlock)
                                .toggleStyle(CustomToggleStyle())
                                .labelsHidden()
                        }
                    }
                    .font(AppFonts.bodyTwentyBold)
                    .foregroundStyle(.appBlue)
                    .padding(.horizontal, 40)
                }
                .padding(.horizontal)
            }
            Spacer()
            Button {} label: {
                Text("Submit")
                    .customButtonStyleWithBordered()
            }
            .padding()
            BottomNavigation()
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
    }
    
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
}

#Preview {
    CardStatusView(viewModel: .init())
}
