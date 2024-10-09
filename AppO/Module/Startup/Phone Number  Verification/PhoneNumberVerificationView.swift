//
//  PhoneNumberVerificationView.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import SwiftUI
import Combine

struct PhoneNumberVerificationView: View {
    
    @StateObject var viewModel: PhoneNumberVerificationViewModel
    @EnvironmentObject var navigator: Navigator
    
    @State private var navigateToNextScreen = false
    @State var showPopup = false
    @State var presentSheet = false
    @State var countryCode : String = ""
    @State var countryFlag : String = ""
    @State var countryPattern : String = ""
    @State var countryLimit : Int = 0
    @State var mobPhoneNumber = ""
    @State var countryName = ""
    @State private var searchCountry: String = ""
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var keyIsFocused: Bool
    
    let counrties: [PhoneNumberModel] = Bundle.main.decode("CountryNumbers.json")
    @State var cleanedNumber: String = ""
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(2)
            NavigationBarView(title: viewModel.isBindingNewDevice ? "Back" : "Phone no Verification")
                .zIndex(1)
            Rectangle()
                .fill(Color.appBlue)
                .frame(height: 450)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Image("appo-cardlogo")
                    .resizable()
                    .frame(width: 120, height: 100)
                
                VStack(spacing: 5) {
                    Text(viewModel.isBindingNewDevice ? "Welcome Back" : "Verify Code")
                        .foregroundStyle(Color.appBlueForeground)
                        .font(AppFonts.regularTwenty)
                    
                    Text(viewModel.isBindingNewDevice ? "Phone Number" : "Phone No Verification")
                        .foregroundStyle(Color.white)
                        .font(AppFonts.regular3)
                    
                    Text(viewModel.isBindingNewDevice ? "You need to provide a phone number to bind new a device" : "We will send you the OTP")
                        .foregroundStyle(Color.white)
                        .font(AppFonts.regularTwentyTwo)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                ZStack {
                    Rectangle()
                        .fill(Color.appBlueForeground)
                    HStack {
                        Button {
                            lightHaptic()
                            presentSheet = true
                            keyIsFocused = false
                        } label: {
                            HStack {
                                if self.countryCode.isEmpty {
                                    Spacer()
                                    Text("Select Country")
                                        .font(AppFonts.bodyFourteenBold)
                                        .foregroundStyle(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .padding(.trailing, 5)
                                        .foregroundStyle(.black)
                                } else {
                                    Text("\(self.countryFlag)")
                                        .font(AppFonts.headline4)
                                        .padding(.leading, 5)
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
                        .frame(width: 100, height: 60)
                        
                        TextField("", text: self.$mobPhoneNumber)
                            .placeholder(when: self.mobPhoneNumber.isEmpty) {
                                Text("Enter Phone Number")
                                    .font(AppFonts.bodyEighteenBold)
                                    .foregroundColor(.appBlue)
                            }
                            .font(AppFonts.bodyEighteenBold)
                            .focused($keyIsFocused)
                            .keyboardType(.numberPad)
                            .onReceive(Just(self.mobPhoneNumber)) { _ in
                                applyPatternOnNumbers(&self.mobPhoneNumber, pattern: countryPattern, replacementCharacter: "#")
                            }
                            .onChange(of: self.mobPhoneNumber) { _ in
                                if self.mobPhoneNumber.count >= countryLimit {
                                    keyIsFocused = false
                                }
                            }
                            .padding(10)
                    }
                }
                .cornerRadius(10, corners: .allCorners)
                .frame(height: 60)
                .padding()
            }
            .zIndex(1)
            .offset(y: 100)
            CurvedShape()
                .fill(Color.appBlue)
                .frame(height: 100)
                .offset(y: 450)
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            hideKeyboard()
        }
        .edgesIgnoringSafeArea(.top)
        .animation(.easeInOut(duration: 0.6), value: keyIsFocused)
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
        if showPopup {
            Color.black.opacity(0.67)
                .edgesIgnoringSafeArea(.all) // Dimming background
            
            VStack(alignment: .leading, spacing: 20) {
                Text("You enter a phone number")
                    .font(.title2)
                HStack {
                    Image("user")
                    Text("\(self.countryCode) \(self.mobPhoneNumber)")
                        .font(.title3)
                        .foregroundStyle(Color.appBlue)
                }
                
                Text("Is this number correct, or do you want to edit?")
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                HStack {
                    Button {
                        withAnimation {
                            showPopup = false
                        }
                    } label: {
                        Text("Edit")
                            .font(.headline)
                            .foregroundColor(Color.appBlue)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            showPopup = false
                        }
                    } label: {
                        Text("Ok")
                            .font(.headline)
                            .foregroundColor(Color.appBlue)
                    }
                }
            }
            .padding(.all, 15)
            .frame(width: 300, height: 250)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .transition(.scale)
            .animation(.easeInOut, value: showPopup)
        }
        
        VStack(spacing: 0) {
            
            ScrollView {
                VStack {}
            }
            Button {
                lightHaptic()
                hideKeyboard()
                if viewModel.isBindingNewDevice {
                    cleanedNumber = self.mobPhoneNumber
                        .replacingOccurrences(of: "(", with: "")
                        .replacingOccurrences(of: ")", with: "")
                        .replacingOccurrences(of: " ", with: "")
                        .replacingOccurrences(of: "-", with: "")
                    viewModel.rebindDevice(mobileNo: self.cleanedNumber)
                } else {
                    Task {
                        do {
                            viewModel.showLoader = true
                            cleanedNumber = self.mobPhoneNumber
                                .replacingOccurrences(of: "(", with: "")
                                .replacingOccurrences(of: ")", with: "")
                                .replacingOccurrences(of: " ", with: "")
                                .replacingOccurrences(of: "-", with: "")
                            let status = try await viewModel.verifyPhoneNumber(mobPhoneNumber: self.cleanedNumber)
                            if status == "Continue" {
                                try await viewModel.sendOTP(mobPhoneNumber: self.cleanedNumber, phoneCode: self.countryCode)
                            }
                        }
                    }
                }
            } label: {
                Text(viewModel.isBindingNewDevice ? "BIND" : "NEXT")
                    .customButtonStyle()
            }
            .padding()
            .disabled(self.countryCode.isEmpty || self.mobPhoneNumber.isEmpty || self.mobPhoneNumber.count != countryLimit || viewModel.showLoader)
            .opacity((self.countryCode.isEmpty || self.mobPhoneNumber.isEmpty || self.mobPhoneNumber.count != countryLimit || viewModel.showLoader) ? 0.7 : 1.0)
            BottomNavigation()
                .zIndex(1)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbar(.hidden, for: .navigationBar)
        .onReceive(viewModel.coordinatorState) { state in
            switch (state.state, state.transferable) {
            case (.confirm, _):
                navigator.navigate(to: .verifyOTP(viewModel: .init(countryCode: self.countryCode, phoneNumber: cleanedNumber, countryFlag: "\(self.countryFlag)", countryName: "\(self.countryName)")))
                
            case (.rebinded, _):
                navigator.navigateBack(to: 0)
                break
            }
        }
        .showError("Error", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
    }
    
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

#Preview {
    PhoneNumberVerificationView(viewModel: .init(bindingDevice: true))
}
