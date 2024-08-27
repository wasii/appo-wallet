//
//  CardStatusView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct CardStatusView: View {
    @State private var cardStatus: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Card Status")
            CardButtonView(cardType: "Visa Gold Card", cardNumber: "423671******0129" ,cardExpiry: "01/30")
            
            Text("You can set below Status of the Card.")
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(Color.black.opacity(0.8))
            
            VStack(alignment: .leading) {
                HStack {
                    RadioButtonField(id: "inactive", label: "InActive", isSelected: cardStatus == "inactive") {
                        cardStatus = "inactive"
                    }
                    Spacer()
                    RadioButtonField(id: "active", label: "Active", isSelected: cardStatus == "active") {
                        cardStatus = "active"
                    }
                }
                HStack {
                    RadioButtonField(id: "lost", label: "Lost", isSelected: cardStatus == "lost") {
                        cardStatus = "lost"
                    }
                    Spacer()
                    RadioButtonField(id: "stolen", label: "Stolen", isSelected: cardStatus == "stolen") {
                        cardStatus = "stolen"
                    }
                }
                HStack {
                    RadioButtonField(id: "tempblock", label: "Temp Block", isSelected: cardStatus == "tempblock") {
                        cardStatus = "tempblock"
                    }
                    Spacer()
                    RadioButtonField(id: "close", label: "Close", isSelected: cardStatus == "close") {
                        cardStatus = "close"
                    }
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 1.15)
            
            Button {} label: {
                Text("Submit")
                    .customButtonStyle()
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    CardStatusView()
}
