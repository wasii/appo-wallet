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
    @State var countryCode : String = "+91"
    @State var countryFlag : String = "🇮🇳"
    @State var countryPattern : String = "#### #### ##"
    @State var countryLimit : Int = 17
    @State var mobPhoneNumber = ""
    @State private var searchCountry: String = ""
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var keyIsFocused: Bool
    
    let counrties: [PhoneNumberModel] = Bundle.main.decode("CountryNumbers.json")
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 20) {
                    // Aapka existing content yahan rahega
                    NavigationBarView(title: "")
                    
                    Image("appopay_new_logo")
                        .resizable()
                        .frame(height: 200)
                        .frame(width: 250)
                    
                    VStack(spacing: 10) {
                        Text("Verify Code")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.appBlue)
                        Text("Phone Number Verification")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                        Text("We will Send you a OTP")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundStyle(Color.appBlue)
                    }
                    
                    HStack {
                        Button {
                            presentSheet = true
                            keyIsFocused = false
                        } label: {
                            HStack {
                                Text("\(self.countryFlag)")
                                    .font(.system(size: 35))
                                    .padding(.leading, 5)
                                Text("\(self.countryCode)")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.appBlue)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .padding(.trailing, 5)
                                
                            }
                        }
                        .frame(width: 100, height: 57)
                        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        
                        TextField("", text: $mobPhoneNumber)
                            .placeholder(when: mobPhoneNumber.isEmpty) {
                                Text("Phone number")
                                    .foregroundColor(.appBlue)
                            }
                            .focused($keyIsFocused)
                            .keyboardType(.numberPad)
                            .onReceive(Just(mobPhoneNumber)) { _ in
                                applyPatternOnNumbers(&mobPhoneNumber, pattern: countryPattern, replacementCharacter: "#")
                            }
                            .onChange(of: mobPhoneNumber) { _ in
                                if mobPhoneNumber.count >= countryLimit {
                                    keyIsFocused = false
                                }
                            }
                            .padding(10)
                            .frame(height: 57)
                            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    
                    Button {
                        withAnimation {
                            hideKeyboard()
                            showPopup = true
                        }
                    } label: {
                        Text("NEXT")
                            .customButtonStyle()
                    }
                    
                    Spacer()
                    
                    BottomNavigation()
                }
                .animation(.easeInOut(duration: 0.6), value: keyIsFocused)
                .padding()
                .toolbar(.hidden, for: .navigationBar)
                .background(.appBackground)
                .onReceive(viewModel.coordinatorState) { state in
                    switch (state.state, state.transferable) {
                    case (.confirm, _):
                        navigator.navigate(to: .verifyOTP(viewModel: .init(countryCode: self.countryCode, phoneNumber: "\(self.mobPhoneNumber)", countryFlag: "\(self.countryFlag)")))
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
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
                                presentSheet = false
                                searchCountry = ""
                            }
                        }
                        .listStyle(.plain)
                        .searchable(text: $searchCountry, prompt: "Your country")
                    }
                    .presentationDetents([.medium, .large])
                }
                .presentationDetents([.medium, .large])
                
                // Popup
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
                                    viewModel.coordinatorStatePublisher.send(.with(.confirm))
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
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    var filteredResorts: [PhoneNumberModel] {
        if searchCountry.isEmpty {
            return counrties
        } else {
            return counrties.filter { $0.name.contains(searchCountry) }
        }
    }
    
    var backgroundColor: Color {
        return Color.black.opacity(0.05)
    }
    
    func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        stringvar = pureNumber
    }
}

#Preview {
    PhoneNumberVerificationView(viewModel: .init())
}
