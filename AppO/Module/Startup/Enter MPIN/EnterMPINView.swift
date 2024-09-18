//
//  EnterMPINView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct EnterMPINView: View {
    
    @State private var otpDigits: [String] = []
    private let maxDigits = 6
    
    @StateObject var viewModel: EnterMPINViewModel
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(2)
            VStack(spacing: 20) {
                NavigationBarView(title: "Sign In")
                ScrollView {
                    VStack(alignment: .center, spacing: 16) {
                        AppLogoView()
                            .frame(width: 220)
                        Text("Sign In to Continue")
                            .foregroundStyle(Color.appBlue)
                            .font(AppFonts.headline4)
                        
                        OTPndNumPad()
                        //                        .padding()
                        
                        VStack(spacing: 16) {
                            createNewAccountView()
                            updateMPINView()
                            confirmButtonView()
                        }
                        .padding()
                    }
                }
                BottomNavigation()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
        .onReceive(viewModel.coordinatorState) { state in
            switch (state.state, state.transferable) {
            case (.confirm, _):
                break
            case (.createNewAccount, _):
                navigator.navigate(to: .phoneNumberVerification(viewModel: .init()))
                break
            case (.forgetPin, _):
                break
            }
        }
    }
    
    private var isSubmitButtonEnabled: Bool {
        return otpDigits.count == maxDigits
    }
    
    //MARK: - OTP Circles and NumPad
    
    private func OTPndNumPad() -> some View {
        VStack {
            HStack(spacing: 16) {
                ForEach(0..<maxDigits, id: \.self) { index in
                    Circle()
                        .strokeBorder(Color.appBlue, lineWidth: 3)
                        .background(Circle().foregroundColor(otpDigits.count > index ? Color.appBlue : Color.appBlueForeground))
                        .frame(width: 40, height: 40)
                }
            }
            .padding(.bottom, 10)
            
            //Number Pad
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    numPadButton("1")
                    numPadButton("2")
                    numPadButton("3")
                }
                HStack(spacing: 16) {
                    numPadButton("4")
                    numPadButton("5")
                    numPadButton("6")
                }
                HStack(spacing: 16) {
                    numPadButton("7")
                    numPadButton("8")
                    numPadButton("9")
                }
                HStack(spacing: 16) {
                    backspaceButton()
                    numPadButton("0")
                    
                }
            }
        }
    }
    
    //MARK: - Create New Account
    private func createNewAccountView() -> some View {
        HStack(spacing: 5) {
            Text("Create a new account?")
                .foregroundStyle(Color.gray)
                .font(AppFonts.bodyEighteenBold)
            Button {
                viewModel.coordinatorStatePublisher.send(.with(.createNewAccount))
            } label: {
                Text("Register Now")
                    .foregroundStyle(Color.appBlue)
                    .font(AppFonts.bodyTwentyBold)
            }
        }
    }
    
    //MARK: - Update MPIN
    private func updateMPINView() -> some View {
        Button {} label: {
            Text("Update MPIN")
                .foregroundStyle(Color.appBlue)
                .font(AppFonts.headline4)
        }
    }
    
    //MARK: - Confirm Button
    private func confirmButtonView() -> some View {
        Button {
            viewModel.showLoader = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                viewModel.showLoader = false
                AppEnvironment.shared.isLoggedIn = true
            }
        } label: {
            Text("CONFIRM")
                .customButtonStyle()
        }
        .disabled(!isSubmitButtonEnabled)
        .opacity(isSubmitButtonEnabled ? 1.0 : 0.5)
    }
    
    // MARK: - Numpad Button
    private func numPadButton(_ number: String) -> some View {
        Button(action: {
            if otpDigits.count < maxDigits {
                otpDigits.append(number)
                print(otpDigits)
            }
        }) {
            Text(number)
                .font(AppFonts.headline2)
                .frame(width: 80, height: 80)
                .foregroundColor(Color.appBlueForeground)
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBlue, lineWidth: 3))
        }
    }
    
    // MARK: - Backspace Button
    private func backspaceButton() -> some View {
        Button(action: {
            if !otpDigits.isEmpty {
                otpDigits.removeLast()
                print(otpDigits)
            }
        }) {
            Image(systemName: "delete.left")
                .font(AppFonts.headline2)
                .frame(width: 80, height: 80)
                .foregroundColor(Color.appBlueForeground)
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBlue, lineWidth: 3))
        }
    }
}

struct EnterMPINView_Previews: PreviewProvider {
    static var previews: some View {
        EnterMPINView(viewModel: .init())
    }
}
