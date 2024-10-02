//
//  CardToCardView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI
import Combine

struct CardToCardView: View {
    let spacedText = "012368768686868".map { String($0) }.joined(separator: " ")

    @State private var cardUID: String = ""
    @State private var amount: String = ""
    @State var presentSheet = false
    @State var countryCode : String = ""
    @State var countryFlag : String = ""
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
            VStack(spacing: 0) {
                NavigationBarView(title: "Card to Card Transfer")
                VStack(alignment: .leading, spacing: 20) {
                    SenderDetailsView
                    ReceiverDetailsView
                    if viewModel.isDetailsFetched {
                        AmountToTransferView
                    }
                }
                .padding()
                
                Spacer()
                Button{
                    Task {
                        do {
                            if try await viewModel.getDataEncryptionKey() {
                                if try await viewModel.getCardNumber() {
                                    if try await viewModel.tranfer_card_to_card() {
                                        print("SUCCESS")
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Text("Transfer")
                        .customButtonStyle()
                }
                .disabled(amount.isEmpty)
                .opacity(amount.isEmpty ? 0.7 : 1.0)
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
                            self.countryFlag = country.flag
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
        .onTapGesture {
            hideKeyboard()
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
                    Text("\(viewModel.selected_card?.maskCardNum ?? "439385******1037")")
                        .font(AppFonts.bodyTwentyBold)
                        .foregroundStyle(.black)
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
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                return
            }
            
            let patternIndex = pattern.index(pattern.startIndex, offsetBy: index)
            let patternCharacter = pattern[patternIndex]
            
            if patternCharacter == replacementCharacter {
                let numberIndex = pureNumber.index(pureNumber.startIndex, offsetBy: index)
                let numberCharacter = pureNumber[numberIndex]
                stringvar.insert(numberCharacter, at: numberIndex)
            } else if patternCharacter != " " {
                pureNumber.insert(patternCharacter, at: pureNumber.index(pureNumber.startIndex, offsetBy: index))
            }
        }
        stringvar = pureNumber
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
                viewModel.getCustomerEnquiry(mobile: self.mobPhoneNumber)
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
        VStack {
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
    }
}
