//
//  EnterMPINView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI
import LocalAuthentication

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
                        
                        VStack(spacing: 16) {
                            createNewAccountView()
                            if AppDefaults.deviceId == nil {
                                bindDeviceView()
                            } else {
                                updateMPINView()
                            }
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
                AppEnvironment.shared.isLoggedIn = true
            case (.createNewAccount, _):
                navigator.navigate(to: .phoneNumberVerification(viewModel: .init(bindingDevice: false)))
                break
            case (.bindDevice, _):
                navigator.navigate(to: .phoneNumberVerification(viewModel: .init(bindingDevice: true)))
            }
        }
        .showError("Error", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
        .onAppear {
            if let mobilePin = AppDefaults.mobilePin {
                print("Customer Mobile Pin: \(mobilePin)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    authenticate()
                }
            }
        }
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // Check if the device supports Face ID or Touch ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.setupAPICalls()
                    } else {
                        // Handle failed authentication
                    }
                }
            }
        } else {
            print("No Biometric Available")
        }
    }
    
    private func setupAPICalls() {
        Task {
            do {
                viewModel.showLoader = true
                let success = try await viewModel.getDMK()
                if success {
                    try await viewModel.verifyPIN(mobilePin: otpDigits.joined())
                }
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
                lightHaptic()
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
    //MARK: - Bind Device
    private func bindDeviceView() -> some View {
        HStack(spacing: 5) {
            Text("Using a new device?")
                .foregroundStyle(Color.gray)
                .font(AppFonts.bodyEighteenBold)
            Button {
                lightHaptic()
                viewModel.coordinatorStatePublisher.send(.with(.bindDevice))
            } label: {
                Text("Bind Device")
                    .foregroundStyle(Color.appBlue)
                    .font(AppFonts.bodyTwentyBold)
            }
        }
    }
    
    //MARK: - Confirm Button
    private func confirmButtonView() -> some View {
        Button {
            self.setupAPICalls()
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
                lightHaptic()
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
                heavyHaptic()
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
