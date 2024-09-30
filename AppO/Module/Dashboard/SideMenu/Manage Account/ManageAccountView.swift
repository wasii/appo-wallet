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
    
    @State private var isMasked: Bool = true
    @State private var wallet_card: [Card] = []
    
    @State private var currentWallet: WalletCardType = .appo
    @State private var isShowTransactionPin: Bool = false
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
                    maskedUnMaskedView
                    textualView
                    WalletTypeView
                    CardStatusView
                    ScrollView(.vertical) {
                        ForEach(wallet_card, id: \.self) { card in
                            CardView
                                .onTapGesture {
                                    showTransactionPinView()
                                }
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
            if isShowTransactionPin {
                GeometryReader { geo in
                    VStack {
                        Spacer()
                        TransactionPinPopUpView(isShowTransactionPin: $isShowTransactionPin) {
                            viewModel.showLoader = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                viewModel.showLoader = false
                                if AppDefaults.temp_pin == AppDefaults.newPIN {
                                    homeNavigator.navigate(to: .transactionsDetails(viewModel: .init()))
                                } else {
                                    viewModel.apiError = "PIN Not Matched"
                                    viewModel.isPresentAlert = true
                                }
                            }
                        }
                    }
                    .transition(.move(edge: .bottom)) // Move from bottom
                    .animation(.easeInOut(duration: 1.4), value: isShowTransactionPin)
                }
            }
        }
        .showError("Error", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            wallet_card = AppDefaults.user?.cardList ?? []
        }
    }
    
    func showTransactionPinView() {
        isShowTransactionPin.toggle()
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
                .foregroundStyle(currentWallet == wallet ? .white : .appBlue)
                .padding()
                .frame(height: 40)
                .background(currentWallet == wallet ? .appBlue : .gray.opacity(0.08))
                .cornerRadius(60)
                .onTapGesture {
                    withAnimation {
                        if wallet.isEnabled {
                            currentWallet = wallet
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
    
    var maskedUnMaskedView: some View {
        HStack {
            Text("Mask")
                .foregroundColor(.appBlue)
                .font(isMasked ? AppFonts.bodyTwentyTwoBold : AppFonts.regularTwentyTwo)
            
            Toggle("", isOn: $isMasked)
                .toggleStyle(CustomToggleStyle())
                .labelsHidden()
            
            Text("UnMask")
                .foregroundColor(.appBlue)
                .font(isMasked ? AppFonts.regularTwentyTwo : AppFonts.bodyTwentyTwoBold)
        }
    }
    
    var textualView: some View {
        VStack(spacing: 5) {
            Text("Tap on Card to see last 10 transactions")
                .font(AppFonts.bodyTwentyBold)
        }
        .foregroundStyle(.appBlue)
    }
    
    var CardView: some View {
        ZStack(alignment: .top) {
            Image("appo-pay-card")
                .resizable()
                .frame(height: 220)
            
            VStack(alignment: .leading) {
                Spacer()
                Text(isMasked ? "6262 2303 **** ****" : "6262 2303 5678 9010")
                    .font(AppFonts.regularTwenty)
                Text("Expiry: 10/2016 JOE CHURCO")
                    .font(AppFonts.bodyFourteenBold)
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 220)
        }
    }
    
    var AppoPayUnionCard: some View {
        ZStack(alignment: .top) {
            Image(isMasked ? "appopay-unionpay-card" : "appopay-unionpay-card-visible")
                .resizable()
                .frame(height: 220)
        }
    }
    
    var AppoPayVisaCard: some View {
        ZStack(alignment: .top) {
            Image("appopay-visa-card")
                .resizable()
                .frame(height: 220)
            
            VStack(alignment: .leading) {
                Spacer()
                Text(isMasked ? "**** 5679" : "5354 5679")
                    .font(AppFonts.regularTwenty)
            }
            .foregroundStyle(.appBlue)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 220)
        }
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
