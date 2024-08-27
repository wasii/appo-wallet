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
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title:"")
            
            Text("Verify your phone number, we have sent an OTP to this \(viewModel.countryCode) \(viewModel.phoneNumber) number.")
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            OTPInputView(otpDigits: $createPIN)
            
            
            VStack(alignment: .center, spacing: 10) {
                Text(timerManager.formattedTime)
                    .font(.title3)
                    .foregroundStyle(Color.appBlue)
                    .padding(.top, -20)
                    
                Text("Didn't received OTP?")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.gray)
                
                Button("Resend Code") {
                    timerManager.resetTimer()
                }
                .disabled(!timerManager.isTimerComplete)
                .opacity(timerManager.isTimerComplete ? 1 : 0.5)
                
                NavigationLink(destination: RegistrationView(countryFlag: "🇮🇳", countryDialingCode: viewModel.countryCode, phoneNumber: viewModel.phoneNumber)) {
                    Text("Verify")
                        .customButtonStyle()
                }
                .padding(.top, 20)
                
                AppLogoView()
                    .padding(.top, 20)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .toolbar(.hidden, for: .navigationBar)
        .background(.appBackground)
        
        .onAppear {
            timerManager.startTimer()
        }
        .onDisappear {
            timerManager.stopTimer()
        }
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
    VerifyOTPView(viewModel: .init(countryCode: "+91", phoneNumber: "1234123412"))
}
