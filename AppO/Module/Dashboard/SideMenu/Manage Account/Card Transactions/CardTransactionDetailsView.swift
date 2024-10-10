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
                    Text("\(viewModel.mini_statement?.acctInfo.availBal ?? "")")
                }
                .foregroundColor(Color.black.opacity(0.7))
                ScrollView {
                    ForEach(viewModel.mini_statement?.additionalInfo.transaction ?? [], id: \.self) { transaction in
                        VStack(alignment:.leading, spacing: 10) {
                            HStack {
                                Text("\(transaction.date ?? "") \(transaction.time ?? "")")
                                    .font(.footnote)
                                Spacer()
                                Text("\(transaction.amount ?? "")")
                                    .foregroundStyle(Color.appOrange)
                            }
                            Text("\(transaction.detail ?? "")")
                                .font(.footnote)
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.appBlue, lineWidth: 1))
                    }
                }
            }
            .padding()
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    CardTransactionDetailsView(viewModel: .init(mini_statement: nil))
}
