//
//  RenewCardView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct RenewCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Renew Card")
            
            CardButtonView(cardType: "Visa Gold Card", cardNumber: "423671******0129" ,cardExpiry: "01/30")
            
            Spacer()
            
            Button {} label: {
                Text("Submit")
                    .customButtonStyle()
            }
        }
        .padding()
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    RenewCardView()
}
