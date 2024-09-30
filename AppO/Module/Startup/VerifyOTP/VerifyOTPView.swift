//
//  VerifyOTPView.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import SwiftUI

struct VerifyOTPView: View {
    @State private var createPIN: [String] = Array(repeating: "", count: 6)
//    @State private var otpText: String = ""
    @StateObject private var timerManager = TimerManager()
    
    @StateObject var viewModel: VerifyOTPViewModel
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(2)
            NavigationBarView(title: "OTP Verification")
                .zIndex(1)
            Rectangle()
                .fill(Color.appBlue)
                .frame(height: 430)
            
            VStack(spacing: 20) {
                Image("appopay-new")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Group {
                    Text("Verify your Phone Number, we have sent an OTP to this ")
                    + Text("\(viewModel.countryCode) \(viewModel.phoneNumber) ")
                        .font(AppFonts.bodyEighteenBold)
                    + Text("number")
                }
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(AppFonts.regularEighteen)
                .frame(width: 310)
                
                
                OTPInputView(otpDigits: $createPIN, isSecure: false)
                
                VStack(alignment: .center, spacing: 10) {
                    Text(timerManager.formattedTime)
                        .font(AppFonts.bodyTwentyBold)
                        .foregroundStyle(Color.appBlueForeground)
                        .padding(.top, -20)
                    
                    Text("Didn't received OTP?")
                        .font(AppFonts.headline4)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                    
                    Button {
                        lightHaptic()
                        timerManager.resetTimer()
                    } label: {
                        Text("Resend Code")
                            .font(AppFonts.bodyTwentyTwoBold)
                            .foregroundStyle(Color.appBlueForeground)
                    }
                    .disabled(!timerManager.isTimerComplete)
                    .opacity(timerManager.isTimerComplete ? 1 : 0.35)
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
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            timerManager.startTimer()
        }
        .onDisappear {
            timerManager.stopTimer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onReceive(viewModel.coordinatorState) { state in
            switch (state.state, state.transferable) {
            case (.verify, _):
                navigator.navigate(
                    to: .setupMobilePin(
                        viewModel: .init(
                            countryFlag: viewModel.countryFlag,
                            countryCode: viewModel.countryCode,
                            phoneNumber: viewModel.phoneNumber,
                            countryName: viewModel.countryName
                        )
                    )
                )
            }
        }
        .showError("Error", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
        
        VStack(spacing: 0) {
            ScrollView {
                VStack {}
            }
            
            Button {
                hideKeyboard()
                lightHaptic()
                //viewModel.coordinatorStatePublisher.send(.with(.verify))
                viewModel.verifyOtp(otp: createPIN.joined())
            } label: {
                Text("VERIFY")
                    .customButtonStyle()
            }
            .padding()
            .disabled(!isSubmitButtonEnabled)
            .opacity(isSubmitButtonEnabled ? 1.0 : 0.7)
            BottomNavigation()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var isSubmitButtonEnabled: Bool {
        return createPIN.allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}

#Preview {
    VerifyOTPView(viewModel: .init(countryCode: "+91", phoneNumber: "1234123412", countryFlag: "🇮🇳", countryName: "India"))
}
