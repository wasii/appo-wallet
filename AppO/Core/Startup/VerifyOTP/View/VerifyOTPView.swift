//
//  VerifyOTPView.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import SwiftUI

struct VerifyOTPView: View {
    
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
                
                OTPInputView()
                
                
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
struct OTPInputView: View {
    @State private var otpDigits: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<6, id: \.self) { index in
                OTPDigitField(digit: $otpDigits[index])
                    .focused($focusedField, equals: index)
                    .onChange(of: otpDigits[index]) { _, newValue in
                        if newValue.count > 1 {
                            otpDigits[index] = String(newValue.last ?? " ")
                        }
                        if newValue.count == 1 {
                            if index < 5 {
                                focusedField = index + 1
                            }
                        } else if newValue.isEmpty {
                            if index > 0 {
                                focusedField = index - 1
                            }
                        }
                        // Dismiss keyboard when all 6 digits are entered
                        if otpDigits.allSatisfy({ !$0.isEmpty }) {
                            focusedField = nil
                            hideKeyboard()
                        }
                    }
            }
        }
        .padding()
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

struct OTPDigitField: View {
    @Binding var digit: String
    
    var body: some View {
        TextField("", text: $digit)
            .font(.title3)
            .foregroundStyle(Color.appYellow)
            .multilineTextAlignment(.center)
            .frame(width: 45, height: 55)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .keyboardType(.numberPad)
            .textInputAutocapitalization(.never) // Prevents autocapitalization
            .disableAutocorrection(true) // Disables autocorrection
            .onChange(of: digit) { _, newValue in
                if newValue.count > 1 {
                    digit = String(newValue.last ?? " ")
                }
            }
    }
}








class TimerManager: ObservableObject {
    @Published var timeRemaining: Int = 60
    @Published var isTimerComplete: Bool = false
    private var timer: Timer?
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimer() {
        timeRemaining = 60 // Reset timer to 1 minute
        isTimerComplete = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timeRemaining = 0
                self.isTimerComplete = true
                timer.invalidate()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func resetTimer() {
        stopTimer()
        startTimer()
    }
}
