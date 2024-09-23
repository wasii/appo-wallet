//
//  OTPInputView.swift
//  AppO
//
//  Created by Abul Jaleel on 19/08/2024.
//

import SwiftUI

struct OTPInputView: View {
    @Binding var otpDigits: [String]
    @FocusState private var focusedField: Int?
    var length: Int = 6
    var isSecure: Bool = false
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<length, id: \.self) { index in
                OTPDigitField(digit: $otpDigits[index], isSecure: isSecure)
                    .focused($focusedField, equals: index)
                    .onChange(of: otpDigits[index]) { newValue in
                        lightHaptic()
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
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField("", text: $digit)
            } else {
                TextField("", text: $digit)
            }
        }
        .font(AppFonts.headline4)
        .foregroundStyle(Color.appBlue)
        .multilineTextAlignment(.center)
        .frame(width: 45, height: 45)
        .background(Color.appBlueForeground)
        .clipShape(Circle())
        
        .keyboardType(.numberPad)
        .textInputAutocapitalization(.never) // Prevents autocapitalization
        .disableAutocorrection(true) // Disables autocorrection
        .onChange(of: digit) { newValue in
            if newValue.count > 1 {
                digit = String(newValue.last ?? " ")
            }
        }
    }
}

