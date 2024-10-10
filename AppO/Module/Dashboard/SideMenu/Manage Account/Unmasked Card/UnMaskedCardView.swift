//
//  UnMaskedCardView.swift
//  AppO
//
//  Created by Abul Jaleel on 03/10/2024.
//

import SwiftUI

struct UnMaskedCardView: View {
    @Binding var isUnMaskedCardViewVisible: Bool
    var card: Card? = nil
    var unmaskedValue: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                Image(card?.cardImage ?? "")
                    .resizable()
                    .frame(height: 220)
                
                VStack(alignment: .leading) {
                    Spacer()
                    Text(Formatters.formatCreditCardNumber(unmaskedValue))
                        .font(AppFonts.regularTwenty)
                    Text("Expiry: \(Formatters.convertDateToMonthYear(card?.expDate ?? "") ?? "") \(card?.cardName ?? "")")
                        .font(AppFonts.bodyFourteenBold)
                }
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 220)
            }
            
            Spacer()
            VStack(alignment: .trailing) {
                Button {
                    isUnMaskedCardViewVisible = false
                } label: {
                    Text("CLOSE")
                        .customButtonStyle()
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
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
    UnMaskedCardView(isUnMaskedCardViewVisible: .constant(true))
}
