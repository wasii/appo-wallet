//
//  ChangeTransactionPinView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct ChangeTransactionPinView: View {
    
    @State private var selectedCard: Card?
    @State private var currentIndex: Int = 0
    
    var walletTypes: [WalletCardType] {
        WalletCardType.allCases
    }
    
    @StateObject var viewModel: ChangeTransactionPinViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    @State private var oldPIN: [String] = Array(repeating: "", count: 4)
    @State private var newPIN: [String] = Array(repeating: "", count: 4)
    @State private var confirmPIN: [String] = Array(repeating: "", count: 4)
    
    
    @State private var oldPinSwitch: Bool = false
    @State private var createPinSwitch: Bool = false
    @State private var confirmPinSwitch: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Change Transaction Pin")
            
            VStack(alignment: .leading, spacing: 20) {
                ScrollView {
                    Text("do not share your pin with anyone and keep it in a safe place.")
                        .textCase(.uppercase)
                        .foregroundStyle(.appBlue)
                        .font(AppFonts.regularTwenty)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(spacing: 20) {
                        WalletTypeView
                        CardView
                    }
                    .padding(.top, 20)
                    
                    VStack {
                        OldPinView
                        NewPinView
                        ConfirmPinView
                    }
                    .frame(width: 320)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button {
                        Task {
                            viewModel.showLoader = true
                            do {
                                if try await viewModel.getDataEncryptionKey() {
                                    if try await viewModel.getCardNumber(cardRefNum: viewModel.selected_card?.cardRefNum ?? "") {
                                        AppDefaults.temp_pin = oldPIN.joined()
                                        let oldPin = CryptoUtils.main() ?? ""
                                        AppDefaults.temp_pin = newPIN.joined()
                                        let newPin = CryptoUtils.main() ?? ""
                                        
                                        if try await viewModel.setCardPin(oldPin: oldPin, newPin: newPin) {
                                            print("SUCCESS")
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
                    } label: {
                        Text("Submit")
                            .font(AppFonts.headline4)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(isSubmitEnabled ? .appBlue : .appBlue.opacity(0.7))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .disabled(!isSubmitEnabled)
                }
            }
            .padding()
            Spacer()
            
            BottomNavigation()
        }
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.top)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onTapGesture {
            hideKeyboard()
        }
        .showError("", viewModel.apiError, isPresenting: $viewModel.isPresentAlert) {
            homeNavigator.navigateToRoot()
        }
    }
    
    var isSubmitEnabled: Bool {
        return !oldPIN.contains("") && !newPIN.contains("") && !confirmPIN.contains("") && newPIN == confirmPIN
    }
}

extension ChangeTransactionPinView {
    var OldPinView: some View {
        VStack {
            HStack {
                Text("Old Pin")
                    .font(AppFonts.bodyTwentyBold)
                Spacer()
                Text("Enable")
                    .font(AppFonts.regularSixteen)
                
                Toggle("", isOn: $oldPinSwitch)
                    .toggleStyle(CustomToggleStyle())
                    .labelsHidden()
            }
            .foregroundStyle(Color.appBlue)
            .padding(.top, 20)
            
            OTPInputView(otpDigits: $oldPIN, length: 4, isSecure: true)
                .padding(.top, -10)
        }
    }
    
    var NewPinView: some View {
        VStack {
            HStack {
                Text("New Pin")
                    .font(AppFonts.bodyTwentyBold)
                Spacer()
                Text("Enable")
                    .font(AppFonts.regularSixteen)
                Toggle("Enable", isOn: $createPinSwitch)
                    .toggleStyle(CustomToggleStyle())
                    .labelsHidden()
            }
            .foregroundStyle(Color.appBlue)
            .padding(.top, 20)
            
            OTPInputView(otpDigits: $newPIN, length: 4, isSecure: true)
                .padding(.top, -10)
        }
    }
    
    var ConfirmPinView: some View {
        VStack {
            HStack {
                Text("Confirm New Pin")
                    .font(AppFonts.bodyTwentyBold)
                Spacer()
                Text("Enable")
                    .font(AppFonts.regularSixteen)
                Toggle("Enable", isOn: $confirmPinSwitch)
                    .toggleStyle(CustomToggleStyle())
                    .labelsHidden()
            }
            .foregroundStyle(Color.appBlue)
            .padding(.top, 20)
            
            OTPInputView(otpDigits: $confirmPIN, length: 4, isSecure: true)
                .padding(.top, -10)
        }
    }
}

extension ChangeTransactionPinView {
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
                            Text("Expiry: \(Formatters.convertDateToMonthYear(card.expDate ?? "") ?? "") \(Formatters.formatCreditCardNumber(card.cardName ?? ""))")
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
    ChangeTransactionPinView(viewModel: .init())
}
