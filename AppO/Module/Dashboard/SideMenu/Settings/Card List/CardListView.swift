//
//  CardListView.swift
//  AppO
//
//  Created by Abul Jaleel on 08/10/2024.
//

import SwiftUI

struct CardListView: View {
    @StateObject var viewModel: CardListViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    @State private var currentIndex: Int = 0
    
    var walletTypes: [WalletCardType] {
        WalletCardType.allCases
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Card List")
            VStack(alignment: .center, spacing: 20) {
                WalletTypeView
                CardView
                
                HStack {
                    Text("Available Balance")
                        .foregroundStyle(Color.appBlue)
                        .font(AppFonts.bodyTwentyBold)
                    Text("USD : \(viewModel.selected_card?.walletInfo?.availBal ?? "0.00")")
                        .foregroundStyle(Color.black.opacity(0.8))
                        .font(AppFonts.bodyTwentyBold)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            
            Spacer()
            BottomNavigation()
        }
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
        .showError("", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
        .onReceive(viewModel.coordinatorState) { state in
            switch (state.state, state.transferable) {
            case (.card, _):
                homeNavigator.navigateBack(to: 1)
                AppDefaults.temp_card = viewModel.selected_card
            }
        }
        .onAppear {
            viewModel.getCustpmerEnquiry()
        }
    }
}

#Preview {
    CardListView(viewModel: .init())
}


extension CardListView {
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
                    CardItemView(card: card)
                        .tag(index)
                        .onChange(of: currentIndex) { newIndex in
                            handleCardChange(newIndex: newIndex)
                        }
                        .onTapGesture {
                            handleCardTap()
                        }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 220)
            .onAppear {
                selectFirstCard()
            }
        }
    }

    // Helper subviews and functions
    private func handleCardChange(newIndex: Int) {
        if let card = viewModel.cards?[newIndex] {
            heavyHaptic()
            viewModel.selected_card = card
        }
    }

    private func handleCardTap() {
        if let balanceString = viewModel.selected_card?.walletInfo?.availBal,
           let balance = Double(balanceString), balance < 0.0 {
            errorHaptic()
        } else {
            viewModel.coordinatorStatePublisher.send(.with(.card))
        }
    }

    private func selectFirstCard() {
        if let firstCard = viewModel.cards?.first {
            viewModel.selected_card = firstCard
        }
    }

    struct CardItemView: View {
        let card: Card
        
        var body: some View {
            ZStack {
                Image(card.cardImage ?? "")
                    .resizable()
                    .frame(height: 220)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                
                VStack(alignment: .leading) {
                    Spacer()
                    Text(card.maskCardNum ?? "")
                        .font(AppFonts.regularTwenty)
                    Text("Expiry: \(String(describing: Formatters.convertDateToMonthYear(card.expDate ?? "") ?? "")) \(card.cardName ?? "")")
                        .font(AppFonts.bodyFourteenBold)
                }
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
