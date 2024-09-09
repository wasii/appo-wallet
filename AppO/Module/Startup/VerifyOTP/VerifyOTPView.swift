//
//  VerifyOTPView.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import SwiftUI

struct VerifyOTPView: View {
    @State private var createPIN: [String] = Array(repeating: "", count: 6)
    @State private var otpText: String = ""
    @StateObject private var timerManager = TimerManager()
    
    @StateObject var viewModel: VerifyOTPViewModel
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ZStack(alignment: .top) {
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
        
        VStack(spacing: 0) {
            ScrollView {
                VStack {}
            }
            
            Button {
                hideKeyboard()
                viewModel.coordinatorStatePublisher.send(.with(.verify))
            } label: {
                Text("VERIFY")
                    .customButtonStyle()
            }
            .padding()
            BottomNavigation()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func getDigit(at index: Int) -> String {
        if index < otpText.count {
            let startIndex = otpText.index(otpText.startIndex, offsetBy: index)
            return String(otpText[startIndex])
        }
        return ""
    }
}

#Preview {
    VerifyOTPView(viewModel: .init(countryCode: "+91", phoneNumber: "1234123412", countryFlag: "🇮🇳"))
}
