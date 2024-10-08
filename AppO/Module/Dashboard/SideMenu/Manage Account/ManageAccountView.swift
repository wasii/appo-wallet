//
//  ManageAccountView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct ManageAccountView: View {
    @StateObject var viewModel: ManageAccountViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Manage Account")
            
            Text("Tap on Card to see last 10\nTransactions")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Button {
                homeNavigator.navigate(to: .transactionsDetails(viewModel: .init()))
            } label: {
                CardButtonView(cardType: "Visa Gold Card", cardNumber: "423671******0129" ,cardExpiry: "01/30")
            }
            Spacer()
        }
        .padding()
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ManageAccountView(viewModel: .init())
}
