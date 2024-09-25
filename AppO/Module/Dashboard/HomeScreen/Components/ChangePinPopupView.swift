//
//  ChangePinPopupView.swift
//  AppO
//
//  Created by Abul Jaleel on 25/09/2024.
//

import SwiftUI

struct ChangePinPopupView: View {
    @Binding var isShowChangePin: Bool
    var closure: (()->())
    var body: some View {
        VStack(alignment: .center) {
            Text("Please Change your Pin")
                .font(AppFonts.bodyTwentyTwoBold)
            Text("Your card Transaction PIN has been set. To activate your card, please change the PIN again. Your card will be activated, and then you will be able to use the AppO Service.")
                .font(AppFonts.regularTwentyTwo)
                .padding(.top, 5)
            
            
            Spacer()
            VStack {
                HStack(spacing: 20) {
                    Button{
                        isShowChangePin = false
                        closure()
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
        .multilineTextAlignment(.leading)
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
    ChangePinPopupView(isShowChangePin: .constant(true)) {}
}
