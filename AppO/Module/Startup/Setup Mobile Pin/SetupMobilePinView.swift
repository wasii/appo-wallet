//
//  SetupMobilePinView.swift
//  AppO
//
//  Created by Abul Jaleel on 19/08/2024.
//

import SwiftUI

struct SetupMobilePinView: View {
    
    @StateObject var viewModel: SetupMobilePinViewModel
    @EnvironmentObject var navigator: Navigator
    
    @State private var createPIN: [String] = Array(repeating: "", count: 6)
    @State private var confirmPIN: [String] = Array(repeating: "", count: 6)
    
    @State private var isCreatePINSecure: Bool = true
    @State private var isConfirmPINSecure: Bool = true
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationBarView(title: "Mobile PIN")
                .zIndex(1)
            Rectangle()
                .fill(Color.appBlue)
                .frame(height: 430)
            
            VStack(spacing: 20) {
                Text("Upddate your Pin")
                    .foregroundStyle(Color.appBlueForeground)
                    .font(AppFonts.headline3)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Create Mobile Pin")
                        Spacer()
                        Button {
                            isCreatePINSecure.toggle()
                        } label: {
                            Image(systemName: isCreatePINSecure ? "eye.slash" : "eye")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .font(AppFonts.regularTwentyTwo)
                    .foregroundStyle(Color.white)
                    OTPInputView(otpDigits: $createPIN, length: 6, isSecure: isCreatePINSecure)
                }
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Confirm Mobile Pin")
                        Spacer()
                        Button {
                            isConfirmPINSecure.toggle()
                        } label: {
                            Image(systemName: isConfirmPINSecure ? "eye.slash" : "eye")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .font(AppFonts.regularTwentyTwo)
                    .foregroundStyle(Color.white)
                    OTPInputView(otpDigits: $confirmPIN, length: 6, isSecure: isCreatePINSecure)
                }
            }
            .zIndex(1)
            .offset(y: 100)
            
            CurvedShape()
                .fill(Color.appBlue)
                .frame(height: 100)
                .offset(y: 430)
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        
        VStack {
            ScrollView {
                VStack {}
            }
            
            Button {
                hideKeyboard()
//                AppEnvironment.shared.isLoggedIn = true
                viewModel.mobilePin = createPIN.joined()
                viewModel.updatePIN()
            } label: {
                Text("VERIFY")
                    .customButtonStyle()
            }
            .padding()
            .disabled(!isSubmitButtonEnabled)
            .opacity(isSubmitButtonEnabled ? 1.0 : 0.7)
            BottomNavigation()
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .onReceive(viewModel.coordinatorState) { state in
            switch (state.state, state.transferable) {
            case (.verify, _):
                navigator.navigate(
                    to: .registration(
                        viewModel: .init(
                            countryFlag: viewModel.countryFlag,
                            countryCode: viewModel.countryCode,
                            phoneNumber: viewModel.phoneNumber
                        )
                    )
                )
            }
        }
        .showError(viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
    }
    
    private var isSubmitButtonEnabled: Bool {
        let areBothPINsFilled = createPIN.allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } &&
        confirmPIN.allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        let areBothPINsIdentical = createPIN == confirmPIN
        
        return areBothPINsFilled && areBothPINsIdentical
    }
}

#Preview {
    SetupMobilePinView(viewModel: .init(countryFlag: "🇮🇳", countryCode: "+91", phoneNumber: "1234123412"))
}
