//
//  ManageAccountView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct ManageAccountView: View {
    @StateObject var viewModel: ManageAccountViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    
    @State var card: Card? = nil
    
    
    var walletTypes: [WalletCardType] {
        WalletCardType.allCases
    }
    var body: some View {
        ZStack {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(1)
            VStack(spacing: 0) {
                NavigationBarView(title: "Manage Account")
                VStack(spacing: 20) {
                    WalletTypeView
                    textualView
                    
                    CardStatusView
                    ScrollView(.vertical) {
                        ForEach(viewModel.cards ?? [], id: \.self) { card in
                            CardView(card: card)
                                .onTapGesture {
                                    lightHaptic()
                                    self.card = card
                                    showTransactionPinView()
                                }
                                .onLongPressGesture(minimumDuration: 1.0, pressing: { bool in print(bool)}, perform: {
                                    Task {
                                        do {
                                            heavyHaptic()
                                            viewModel.showLoader = true
                                            let success = try await viewModel.getCardNumber(cardRefNum: card.cardRefNum ?? "")
                                            if success {
                                                viewModel.showLoader = false
                                                self.card = card
                                                showUnMaskedCard()
                                            } else {
                                                viewModel.showLoader = true
                                            }
                                        }
                                    }
                                })
                        }
                    }
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                    .scrollIndicators(.hidden)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                Spacer()
                
                BottomNavigation()
            }
            if viewModel.isShowTransactionPin {
                GeometryReader { geo in
                    VStack {
                        Spacer()
                        TransactionPinPopUpView(isShowTransactionPin: $viewModel.isShowTransactionPin) {
                            Task {
                                viewModel.showLoader = true
                                do {
                                    if try await viewModel.getDataEncryptionKey() {
                                        if try await viewModel.getCardNumber(cardRefNum: self.card?.cardRefNum ?? "") {
                                            if try await viewModel.get_mini_statement() {
                                                viewModel.showLoader = false
                                                
                                            } else {
                                                viewModel.showLoader = false
                                            }
                                        } else {
                                            viewModel.showLoader = false
                                        }
                                    } else {
                                        viewModel.showLoader = false
                                    }
                                }
                            }
                            
                        }
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 1.4), value: viewModel.isShowTransactionPin)
                }
            }
            
            if viewModel.isShowUnMaskedCard {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        UnMaskedCardView(isUnMaskedCardViewVisible: $viewModel.isShowUnMaskedCard, card: self.card, unmaskedValue: viewModel.unmaskedCardNumber)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                            .frame(width: geometry.size.width, height: 320)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        Spacer()
                    }
                    .background(Color.black.opacity(0.55).edgesIgnoringSafeArea(.all))
                }
                .zIndex(1.0)
            }
        }
        .showError("Error", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func showTransactionPinView() {
        viewModel.isShowTransactionPin = true
    }
    
    func showUnMaskedCard() {
        viewModel.isShowUnMaskedCard = true
    }
}

extension ManageAccountView {
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
                    withAnimation {
                        if viewModel.changeWalletType(cardType: wallet) {
                            viewModel.currentWallet = wallet
                            viewModel.populateCards(cardType: wallet)
                        }
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
            + Text(AppDefaults.selected_card?.cardStatusDesc ?? "")
                .font(AppFonts.bodyEighteenBold)
        }
        .foregroundStyle(.appBlue)
    }
    
    
    var textualView: some View {
        VStack(spacing: 5) {
            Text("Tap on Card to see last 10 transactions")
                .font(AppFonts.bodyTwentyBold)
        }
        .foregroundStyle(.appBlue)
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? .appBlue : Color.gray)// : .appBlue)
                .frame(width: 60, height: 30)
                .overlay(
                    Image(systemName: "pause.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .offset(x: configuration.isOn ? -15 : 15)
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}



#Preview {
    ManageAccountView(viewModel: .init())
}


struct CardView: View {
    var card: Card
    var body: some View {
        ZStack(alignment: .top) {
            Image(card.cardImage ?? "")
                .resizable()
                .frame(height: 220)
            
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
            .frame(height: 220)
        }
    }
}
