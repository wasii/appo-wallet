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
    
    var countryCode: String
    var phoneNumber: String
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                NavigationBarView(title:"")
                
                Text("Verify your phone number, we have sent an OTP to this \(countryCode) \(phoneNumber) number.")
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
                    
                    NavigationLink(destination: RegistrationView(countryFlag: "🇮🇳", countryDialingCode: self.countryCode, phoneNumber: self.phoneNumber)) {
                        Text("Verify")
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.appBlue)
                            .clipShape(Capsule())
                            .foregroundColor(.white)
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
    VerifyOTPView(countryCode: "+91", phoneNumber: "1234123412")
}
