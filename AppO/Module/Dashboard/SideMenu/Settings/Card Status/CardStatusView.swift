//
//  CardStatusView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct CardStatusView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Card Status")
            CardButtonView(cardType: "Visa Gold Card", cardNumber: "423671******0129" ,cardExpiry: "01/30")
            
            Text("You can set below Status of the Card.")
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(Color.black.opacity(0.8))
            
            
            Spacer()
        }
        .padding()
        .background(Color.appBackground)
    }
}

#Preview {
    CardStatusView()
}
