//
//  EnterMPINView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct EnterMPINView: View {
    
    @State private var otp = ""
    @Binding var text: String
    
    private let otpLength = 6
    
    let rows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["Clear", "0", "Confirm"]
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack {
                    NavigationBarView(title: "")
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        AppLogoView()
                        
                        Text("Sign in to Continue")
                            .foregroundStyle(Color.appBlue)
                            .fontWeight(.semibold)
                            .font(.title2)
                        
                        HStack(alignment: .center) {
                            Spacer()
                            ForEach(0..<otpLength, id: \.self) { index in
                                OTPTextField(text: self.$otp, index: index)
                            }
                            Spacer()
                        }
                        .padding()
                        
                        VStack {
                            ForEach(rows, id: \.self) { row in
                                HStack(spacing: 20) {
                                    ForEach(row, id: \.self) { item in
                                        Button(action: {
                                            self.handleAction(for: item)
                                        }) {
                                            Text(item)
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color.appBlue)
                                                .frame(width: 90, height: 90)
                                                .background(Color.backButton.opacity(0.5))
                                                .cornerRadius(45)
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    VStack(alignment: .center, spacing: 5) {
                        NavigationLink {
                            PhoneNumberVerificationView()
                        } label: {
                            Text("Create new account?")
                                .foregroundStyle(Color.gray)
                                .font(Font.system(size: 20))
                            Text("**Signup**")
                                .foregroundStyle(Color.appYellow)
                                .font(Font.system(size: 20))
                        }
                    }
                    .padding(.top, 30)
                    
                    VStack(alignment: .center, spacing: 5) {
                        NavigationLink {} label: {
                            Text("Forgot MPIN")
                                .foregroundStyle(Color.red)
                                .fontWeight(.semibold)
                                .font(Font.system(size: 18))
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
            .toolbar(.hidden, for: .navigationBar)
            .background(.appBackground)
        }
    }
    
    private func handleAction(for item: String) {
        switch item {
        case "Clear":
            self.otp = ""
        case "Confirm":
            print("OTP Entered: \(self.otp)")
        default:
            if otp.count < otpLength {
                self.otp.append(item)
                print("Current OTP: \(self.otp)") // Print current OTP after appending new value
            }
        }
    }
}

struct OTPTextField: View {
    @Binding var text: String
    let index: Int
    
    var body: some View {
        SecureField("", text: Binding(
            get: {
                let start = text.index(text.startIndex, offsetBy: index, limitedBy: text.endIndex) ?? text.endIndex
                let end = text.index(start, offsetBy: 1, limitedBy: text.endIndex) ?? text.endIndex
                return String(text[start..<end])
            },
            set: { newValue in
                let start = text.index(text.startIndex, offsetBy: index, limitedBy: text.endIndex) ?? text.endIndex
                let end = text.index(start, offsetBy: 1, limitedBy: text.endIndex) ?? text.endIndex
                let updatedText = text.prefix(upTo: start) + newValue.prefix(1) + text.dropFirst(text.distance(from: text.startIndex, to: end))
                text = String(updatedText)
            }
        ))
        .frame(width: 40, height: 40)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        .multilineTextAlignment(.center)
        .textContentType(.oneTimeCode) // Helps with numeric keyboard
    }
}

struct EnterMPINView_Previews: PreviewProvider {
    static var previews: some View {
        EnterMPINView(text: .constant(""))
    }
}
