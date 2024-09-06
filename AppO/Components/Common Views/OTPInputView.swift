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
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<6, id: \.self) { index in
                OTPDigitField(digit: $otpDigits[index])
                    .focused($focusedField, equals: index)
                    .onChange(of: otpDigits[index]) { newValue in
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
            .onChange(of: digit) { newValue in
                if newValue.count > 1 {
                    digit = String(newValue.last ?? " ")
                }
            }
    }
}

