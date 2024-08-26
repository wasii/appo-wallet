//
//  CardButtonView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct CardButtonView: View {
    var cardType: String = ""
    var cardNumber: String = ""
    var cardExpiry: String = ""
    var body: some View {
        ZStack(alignment: .trailing) {
            Image("card_design")
                .resizable()
                .frame(height: 220)
            
            VStack(alignment: .trailing) {
                Text(cardType)
                    .font(.title2)
                Spacer()
                Text(cardNumber)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                Spacer()
                Text(cardExpiry)
                    .font(.title2)
            }
            .padding()
        }
        .foregroundColor(.black)
        .frame(maxHeight: 220)
    }
}

#Preview {
    CardButtonView(cardType: "Visa Gold Card", cardNumber: "423671******0129" ,cardExpiry: "01/30")
}
