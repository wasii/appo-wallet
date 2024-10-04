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
    
    @State private var isActive: Bool = false
    @State private var currentIndex: Int = 0
    
    var walletTypes: [WalletCardType] {
        WalletCardType.allCases
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(1)
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
                            Text("Active")
                            Toggle("", isOn: $isActive)
                                .toggleStyle(CustomToggleStyle())
                                .labelsHidden()
                            Text("Block")
                        }
                        .font(AppFonts.bodyTwentyBold)
                        .foregroundStyle(.appBlue)
                        .padding(.horizontal, 40)
                    }
                    .padding(.horizontal)
                }
                Spacer()
                Button {
                    let cardStatus = self.isActive ? "007" : "008"
                    Task {
                        do {
                            try await viewModel.changeCardStatus(cardStatus: cardStatus)
                        }
                    }
                } label: {
                    Text("Submit")
                        .customButtonStyleWithBordered()
                }
                .padding()
                BottomNavigation()
            }
            .edgesIgnoringSafeArea(.top)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                if viewModel.cards?.first?.cardStatusDesc == "Active" {
                    self.isActive = true
                }
            }
            .showError("", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
        }
    }
}

extension CardStatusView {
    var WalletTypeView: some View {
        HStack {
            Spacer()
            ForEach(walletTypes, id: \.self) { wallet in
                HStack {
                    Text(wallet.title)
                }
                .foregroundStyle(viewModel.currentWallet == wallet ? .white : .appBlue)
                .padding()
                .frame(height: 40)
                .background(viewModel.currentWallet == wallet ? .appBlue : .gray.opacity(0.08))
                .cornerRadius(60)
                .onTapGesture {
                    lightHaptic()
                    withAnimation {
                        if viewModel.changeWalletType(cardType: wallet) {
                            viewModel.currentWallet = wallet
                            viewModel.populateCards(cardType: wallet)
                            self.isActive = viewModel.selected_card?.cardStatusDesc == "Active" ? true : false
                            currentIndex = 0
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    var CardView: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(Array((viewModel.cards ?? []).enumerated()), id: \.element) { index, card in
                    ZStack {
                        Image(card.cardImage ?? "")
                            .resizable()
                            .frame(height: 220)
                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(card.maskCardNum ?? "")
                                .font(AppFonts.regularTwenty)
                            Text("Expiry: \(card.expDate ?? "") \(card.cardName ?? "")")
                                .font(AppFonts.bodyFourteenBold)
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .tag(index)
                    .onChange(of: currentIndex) { newIndex in
                        if let card = viewModel.cards?[newIndex] {
                            heavyHaptic()
                            viewModel.selected_card = card
                            if card.cardStatusDesc == "Active" {
                                self.isActive = true
                            } else {
                                self.isActive = false
                            }
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 220)
            .onAppear {
                if let firstCard = viewModel.cards?.first {
                    viewModel.selected_card = firstCard
                }
            }
        }
    }
}

#Preview {
    CardStatusView(viewModel: .init())
}
