//
//  CardToCardView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct CardToCardView: View {
    let spacedText = "012368768686868".map { String($0) }.joined(separator: " ")

    @State private var cardUID: String = ""
    @State private var amount: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Card to Card Transfer")
            VStack(alignment: .leading, spacing: 20) {
                Text("From CardUID")
                    .fontWeight(.semibold)
                Text(spacedText)
            }
            .padding(.leading, 20)
            .cardStyle(backgroundColor: .white, cornerRadius: 10, height: 90)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("To CardUID")
                    .fontWeight(.semibold)
                TextField("Enter receiver carduid", text: $cardUID)
                    .keyboardType(.numberPad)
            }
            .padding(.leading, 20)
            .cardStyle(backgroundColor: .white, cornerRadius: 10, height: 90)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Amount to Transfer")
                    .fontWeight(.semibold)
                HStack {
                    Text("$")
                        .foregroundStyle(Color.appBlue)
                        .font(.system(size: 25, weight: .semibold))
                    TextField("Enter amount", text: $amount)
                        .keyboardType(.numberPad)
                        .font(.system(size: 15, weight: .semibold))
                }
            }
            .padding(.leading, 20)
            .cardStyle(backgroundColor: .white, cornerRadius: 10, height: 90)
            
            Button{} label: {
                Text("Submit")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.appBlue))
                    .clipShape(Capsule())
                    .foregroundStyle(Color.white)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.appBackground)
    }
}

#Preview {
    CardToCardView()
}
