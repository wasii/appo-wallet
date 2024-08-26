//
//  CardTransactionDetailsView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct CardTransactionDetailsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Transaction Details")
            
            Text("Mini Statement")
                .foregroundStyle(Color.appBlue)
                .fontWeight(.semibold)
            HStack {
                Text("Available Balance:")
                Text("$123.45")
            }
            .foregroundColor(Color.black.opacity(0.7))
            ScrollView {
                ForEach(transactionDetailsItems, id: \.self) { item in
                    VStack(alignment:.leading, spacing: 10) {
                        HStack {
                            Text(item.dateTime)
                                .font(.footnote)
                            Spacer()
                            Text(item.price)
                                .foregroundStyle(Color.appOrange)
                        }
                        Text(item.details)
                            .font(.footnote)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.appBlue, lineWidth: 1))
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.appBackground)
    }
}

#Preview {
    CardTransactionDetailsView()
}
