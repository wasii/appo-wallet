//
//  CardTransactionDetailsView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct CardTransactionDetailsView: View {
    
    @StateObject var viewModel: CardTransactionDetailsViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Transaction Details")
            VStack(alignment: .leading, spacing: 20) {
                Text("Mini Statement")
                    .foregroundStyle(Color.appBlue)
                    .fontWeight(.semibold)
                HStack {
                    Text("Available Balance:")
                    Text("$123.45")
                }
                .foregroundColor(Color.black.opacity(0.7))
                ScrollView {
//                    ForEach(transactionDetailsItems, id: \.self) { item in
//                        VStack(alignment:.leading, spacing: 10) {
//                            HStack {
//                                Text(item.dateTime)
//                                    .font(.footnote)
//                                Spacer()
//                                Text(item.price)
//                                    .foregroundStyle(Color.appOrange)
//                            }
//                            Text(item.details)
//                                .font(.footnote)
//                        }
//                        .padding()
//                        .overlay(RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color.appBlue, lineWidth: 1))
//                    }
                }
            }
            .padding()
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Task {
                    do {
                        if try await viewModel.getDataEncryptionKey() {
                            if try await viewModel.getCardNumber() {
                                if try await viewModel.get_mini_statement() {
//                                    showChangePin()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CardTransactionDetailsView(viewModel: .init())
}
