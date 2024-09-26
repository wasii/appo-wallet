//
//  ShowAvailableBalancePopupView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/09/2024.
//

import SwiftUI

struct ShowAvailableBalancePopupView: View {
    
    @Binding var isShowAvailableBalancePopupView: Bool
    @Binding var balance: String
    var close: () -> ()
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image("app_logo")
                    .resizable()
                    .frame(height: 30)
                    .frame(width: 100)
                Text("Available Balance")
                    .font(AppFonts.bodyTwentyTwoBold)
                    .foregroundStyle(Color.appBlue)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            ZStack {
               Circle()
                    .fill(.appGreen)
                    .frame(width: 150, height: 150)
                
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
            }
            
            Text("$\(balance)")
                .font(AppFonts.headline2)
            
            Button{
                close()
                isShowAvailableBalancePopupView = false
            } label: {
                Text("Close")
                    .font(AppFonts.bodySixteenBold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.appBlue)
                    )
            }
        }
        .padding()
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
    ShowAvailableBalancePopupView(isShowAvailableBalancePopupView: .constant(true), balance: .constant("10.00"), close: {})
}
