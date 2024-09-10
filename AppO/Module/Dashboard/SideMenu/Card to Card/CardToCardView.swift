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
    
    @StateObject var viewModel: CardToCardViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator

    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView(title: "Card to Card Transfer")
            VStack(alignment: .leading, spacing: 20) {
                SenderDetailsView
                ReceiverDetailsView
            }
            .padding()
            
            Spacer()
            Button{} label: {
                Text("Transfer")
                    .customButtonStyle()
            }
            .padding()
            
            BottomNavigation()
            
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension CardToCardView {
    var SenderDetailsView: some View {
        VStack(alignment: .leading) {
            Text("Sender's Details")
                .font(AppFonts.regularTwentyTwo)
            
            HStack(spacing: 20) {
                Image("dummy-man")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Joe")
                        .font(AppFonts.bodyTwentyBold)
                    Text("Total Balance: ")
                        .font(AppFonts.regularEighteen)
                    + Text("$804")
                        .font(AppFonts.bodyEighteenBold)
                }
                .foregroundStyle(.appBlue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.appBlueForeground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
    
    var ReceiverDetailsView: some View {
        VStack(alignment: .leading) {
            Text("Receiver's Details")
                .font(AppFonts.regularTwentyTwo)
            
            HStack(spacing: 20) {
                Image("dummy-man1")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Marco")
                        .font(AppFonts.bodyTwentyBold)
                    Text("+91 9123456048 ")
                        .font(AppFonts.regularEighteen)
                }
                .foregroundStyle(.appBlue)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Amount to Transfer")
                    .font(AppFonts.regularTwentyTwo)
                HStack {
                    Text("$")
                        .font(AppFonts.bodyTwentyTwoBold)
                    Text("200.00")
                        .font(AppFonts.regularTwentyTwo)
                }
                .foregroundStyle(.appBlue)
                Divider().background(.appBlue)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Exchange Rate")
                    .font(AppFonts.regularTwentyTwo)
                HStack {
                    Text("$")
                        .font(AppFonts.bodyTwentyTwoBold)
                    Text("83.2")
                        .font(AppFonts.regularTwentyTwo)
                }
                .foregroundStyle(.appBlue)
                Divider().background(.appBlue)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Amount to be Credited")
                    .font(AppFonts.regularTwentyTwo)
                HStack {
                    Text("USD")
                        .font(AppFonts.bodyTwentyTwoBold)
                    Text("2.24")
                        .font(AppFonts.regularTwentyTwo)
                }
                .foregroundStyle(.appBlue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.appBlueForeground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
}

#Preview {
    CardToCardView(viewModel: .init())
}
