//
//  SetupMobilePINView.swift
//  AppO
//
//  Created by Abul Jaleel on 25/09/2024.
//

import SwiftUI

struct SetupCardPINView: View {
    @Binding var isShowSetupPin: Bool
    @State private var createPIN: [String] = Array(repeating: "", count: 4)
    
    var closure: ((String)->())
    var body: some View {
        VStack(alignment: .center) {
            Text("Please Set Pin to Activate your Card")
                .font(AppFonts.bodyTwentyTwoBold)
            Text("For your safety, create your personal 4-digit PIN Number. You will need to enter the PIN to complete transactions")
                .font(AppFonts.regularTwentyTwo)
                .padding(.top, 5)
            
            
            Text("Enter PIN")
                .font(AppFonts.bodyTwentyTwoBold)
                .padding(.top, 5)
            
            OTPInputView(backgroundColor: .appBlue, foregroundColor: .appBlueForeground, otpDigits: $createPIN, length: 4, isSecure: false)
            
            Spacer()
            VStack {
                HStack(spacing: 20) {
                    Button{
                        isShowSetupPin = false
                    } label: {
                        Text("Close")
                            .font(AppFonts.bodySixteenBold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appBlue)
                            )
                    }
                    
                    Button{
                        isShowSetupPin = false
                        closure(createPIN.joined())
                    } label: {
                        Text("OK")
                            .font(AppFonts.bodySixteenBold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appBlue)
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.appBlueForeground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
}

#Preview {
    SetupCardPINView(isShowSetupPin: .constant(true)) { _ in }
}
