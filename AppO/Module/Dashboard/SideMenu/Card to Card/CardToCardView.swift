//
//  CardToCardView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI
import Combine

struct CardToCardView: View {
    @State private var cardUID: String = ""
    @State private var amount: String = ""
    @State var presentSheet = false
    @State var countryCode : String = ""
    @State var countryPattern : String = ""
    @State var countryLimit : Int = 0
    @State var mobPhoneNumber = ""
    @State var countryName = ""
    @State private var searchCountry: String = ""
    @FocusState private var keyIsFocused: Bool
    
    
    @StateObject var viewModel: CardToCardViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator

    let counrties: [PhoneNumberModel] = Bundle.main.decode("CountryNumbers.json")
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(1)
            
            if viewModel.isShowTransactionPin {
                GeometryReader { geo in
                    VStack {
                        Spacer()
                        TransactionPinPopUpView(isShowTransactionPin: $viewModel.isShowTransactionPin) {
                            viewModel.showLoader = true
                            self.handleOperations()
                        }
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 1.4), value: viewModel.isShowTransactionPin)
                }
                .zIndex(1.0)
            }
            
            if viewModel.isShowTransactionSuccess {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        TransactionSuccessPopupView(
                            paidTo: viewModel.fetched_user?.custName ?? "",
                            transactionInfo: viewModel.response?.txnInfo) {
                                viewModel.isShowTransactionSuccess = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    homeNavigator.navigateToRoot()
                                }
                            }
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                            .frame(width: geometry.size.width, height: 370)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        Spacer()
                    }
                    .background(Color.black.opacity(0.55).edgesIgnoringSafeArea(.all))
                }
                .zIndex(1.0)
            }
            
            VStack(spacing: 0) {
                NavigationBarView(title: "Card to Card Transfer")
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SenderDetailsView
                        ReceiverDetailsView
                        if viewModel.isDetailsFetched {
                            AmountToTransferView
                        }
                    }
                    .padding()
                }
                Spacer()
                Button{
                    lightHaptic()
                    showTransactionPinView()
                } label: {
                    Text("Transfer")
                        .customButtonStyle()
                }
                .disabled(amount.isEmpty || Double(viewModel.selected_card?.walletInfo?.availBal ?? "0.0") ?? 0.0 <= 0.0 || viewModel.cardRefNum.isEmpty)
                .opacity(amount.isEmpty  || Double(viewModel.selected_card?.walletInfo?.availBal ?? "0.0") ?? 0.0 <= 0.0 || viewModel.cardRefNum.isEmpty ? 0.7 : 1.0)
                .padding()
                
                BottomNavigation()
                
            }
            .ignoresSafeArea(.keyboard)
            .edgesIgnoringSafeArea(.top)
            .toolbar(.hidden, for: .navigationBar)
            .showError("", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
            .sheet(isPresented: $presentSheet) {
                NavigationView {
                    List(filteredResorts) { country in
                        HStack {
                            Text(country.flag)
                            Text(country.name)
                                .font(.headline)
                            Spacer()
                            Text(country.dial_code)
                                .foregroundColor(.secondary)
                        }
                        .onTapGesture {
                            self.countryCode = country.dial_code
                            self.countryPattern = country.pattern
                            self.countryLimit = country.limit
                            self.countryName = country.name
                            presentSheet = false
                            searchCountry = ""
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $searchCountry, prompt: "Your country")
                }
                .presentationDetents([.medium, .large])
            }
        }
        .onReceive(viewModel.coordinatorState) { state in
            switch (state.state, state.transferable) {
            case (.selectCard, _):
                homeNavigator.navigate(to: .cardList(viewModel: .init(showQRDetails: false)))
                break
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            if let card = AppDefaults.temp_card {
                viewModel.selected_card = card
            }
        }
        .onDisappear {
            AppDefaults.temp_card = nil
        }
    }
    
    func showTransactionPinView() {
        viewModel.isShowTransactionPin = true
    }
    
    func showSuccessPopupView() {
        viewModel.isShowTransactionSuccess = true
    }
    
    private func handleOperations() {
        Task {
            do {
                if try await viewModel.getDataEncryptionKey() {
                    if try await viewModel.getCardNumber() {
                        viewModel.amount = self.amount
                        if try await viewModel.tranfer_card_to_card() {
                            viewModel.showLoader = false
                            showSuccessPopupView()
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

extension CardToCardView {
    var SenderDetailsView: some View {
        VStack(alignment: .leading) {
            Text("Sender's Details")
                .font(AppFonts.regularTwentyTwo)
            
            HStack(spacing: 20) {
                Image("dummy-man")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(viewModel.user?.custName ?? "Joe")")
                        .font(AppFonts.bodyTwentyBold)
                    HStack {
                        Text("\(viewModel.selected_card?.maskCardNum ?? "439385******1037")")
                            .font(AppFonts.bodyTwentyBold)
                            .foregroundStyle(.black)
                        Spacer()
                        Button {
                            viewModel.coordinatorStatePublisher.send(.with(.selectCard))
                        } label: {
                            Text("Change")
                                .padding(8)
                                .background(Color.appBlue)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    Text("Total Balance: ")
                        .font(AppFonts.regularEighteen)
                    + Text("$\(viewModel.selected_card?.walletInfo?.availBal ?? "0.0")")
                        .font(AppFonts.bodyEighteenBold)
                }
                .foregroundStyle(.appBlue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.appBlueForeground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
    
    var ReceiverDetailsView: some View {
        VStack(alignment: .leading) {
            Text("Receiver's Details")
                .font(AppFonts.regularTwentyTwo)
            
            if viewModel.isDetailsFetched {
                FetchedReceiverDetailsView
            } else {
                FetchReceiverDetailsView
            }
            Divider().background(.appBlue)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.appBlueForeground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
    
    var AmountToTransferView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Amount to Transfer")
                .font(AppFonts.regularTwentyTwo)
            HStack {
                Text("$")
                    .font(AppFonts.bodyTwentyTwoBold)
                TextField("", text: self.$amount)
                    .onChange(of: amount) { newValue in
                        amount = Formatters.formatAmountInput(newValue)
                        print(newValue)
                    }
                    .placeholder(when: self.amount.isEmpty) {
                        Text("0.00")
                            .font(AppFonts.bodyTwentyTwoBold)
                            .foregroundColor(.appBlue)
                            .opacity(0.3)
                    }
                    .font(AppFonts.bodyTwentyTwoBold)
                    .foregroundColor(.appBlue)
                    .keyboardType(.numberPad)
            }
            Divider().background(.appBlue)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.appBlueForeground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        }
    }
}

#Preview {
    CardToCardView(viewModel: .init())
}

extension CardToCardView {
    var filteredResorts: [PhoneNumberModel] {
        if searchCountry.isEmpty {
            return counrties
        } else {
            return counrties.filter { $0.name.lowercased().contains(searchCountry.lowercased()) }
        }
    }
    
    var backgroundColor: Color {
        return Color.black.opacity(0.05)
    }
    
    func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var patternIndex = pattern.startIndex
        var numberIndex = pureNumber.startIndex
        
        while patternIndex < pattern.endIndex && numberIndex < pureNumber.endIndex {
            let patternCharacter = pattern[patternIndex]
            
            if patternCharacter == replacementCharacter {
                // If it's a replacement character, add the next number
                result.append(pureNumber[numberIndex])
                numberIndex = pureNumber.index(after: numberIndex)
            } else {
                // If it's not a replacement character, add the pattern character (space or other)
                result.append(patternCharacter)
            }
            
            patternIndex = pattern.index(after: patternIndex)
        }
        
        // Append any remaining numbers if the pattern ends but there are still numbers left
        while numberIndex < pureNumber.endIndex {
            result.append(pureNumber[numberIndex])
            numberIndex = pureNumber.index(after: numberIndex)
        }
        
        // Update the string variable
        stringvar = result
    }
}
extension CardToCardView {
    var FetchReceiverDetailsView: some View {
        HStack {
            Button {
                lightHaptic()
                presentSheet = true
                keyIsFocused = false
            } label: {
                HStack {
                    if self.countryCode.isEmpty {
                        Spacer()
                        Text("Code")
                            .font(AppFonts.bodyFourteenBold)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .padding(.trailing, 5)
                            .foregroundStyle(.black)
                    } else {
                        Text("\(self.countryCode)")
                            .font(AppFonts.bodyEighteenBold)
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .padding(.trailing, 5)
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .frame(width: 75, height: 60)
            TextField("", text: self.$mobPhoneNumber)
                .placeholder(when: self.mobPhoneNumber.isEmpty) {
                    Text("Enter Phone Number")
                        .font(AppFonts.bodySixteenBold)
                        .foregroundColor(.appBlue)
                }
                .font(AppFonts.bodyEighteenBold)
                .keyboardType(.numberPad)
                .focused($keyIsFocused)
                .onReceive(Just(self.mobPhoneNumber)) { _ in
                    applyPatternOnNumbers(&self.mobPhoneNumber, pattern: countryPattern, replacementCharacter: "#")
                }
                .onChange(of: self.mobPhoneNumber) { _ in
                    if self.mobPhoneNumber.count >= countryLimit {
                        keyIsFocused = false
                    }
                }
            
            Button {
                let mobile = self.mobPhoneNumber
                    .replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "-", with: "")
                viewModel.getCustomerEnquiry(mobile: mobile)
            } label: {
                Text("Search")
                    .padding()
                    .background(Color.appBlue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .disabled(self.countryCode.isEmpty || self.mobPhoneNumber.isEmpty || self.mobPhoneNumber.count != countryLimit || viewModel.showLoader)
            .opacity((self.countryCode.isEmpty || self.mobPhoneNumber.isEmpty || self.mobPhoneNumber.count != countryLimit || viewModel.showLoader) ? 0.7 : 1.0)
        }
    }
    
    var FetchedReceiverDetailsView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                Image("dummy-man1")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.fetched_user?.custName ?? "Marco")
                        .font(AppFonts.bodyTwentyBold)
                    Text(viewModel.fetched_user?.primaryMobileNum ?? "+91 9123456048 ")
                        .font(AppFonts.regularEighteen)
                }
                .foregroundStyle(.appBlue)
            }
            ForEach(viewModel.fetched_user?.cardList ?? [], id: \.self) { card in
                RadioButtonField(
                    id: card.maskCardNum ?? "",
                    label: card.maskCardNum ?? "",
                    isSelected: viewModel.maskCardNum == card.maskCardNum ?? "",
                    labelColor: .black,
                    labelFont: AppFonts.regularEighteen
                ) {
                    viewModel.maskCardNum = card.maskCardNum ?? ""
                    viewModel.cardRefNum = card.cardRefNum ?? ""
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
