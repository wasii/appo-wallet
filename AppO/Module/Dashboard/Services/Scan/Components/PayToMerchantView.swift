//
//  PayToMerchantView.swift
//  AppO
//
//  Created by Abul Jaleel on 08/10/2024.
//

import SwiftUI

struct PayToMerchantView: View {
    @StateObject var viewModel: ManageAccountViewModel
    @EnvironmentObject var homeNavigator: PayToMerchantViewModel
    
    @State private var amount: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(1)
            VStack(spacing: 0) {
                NavigationBarView(title: "Pay to Merchant")
                
                VStack(spacing: 20) {
                    SenderDetailsView
                    AmountToTransferView
                }
                .padding()
                
                Spacer()
                
                Button {} label: {
                    Text("Next")
                        .customButtonStyle()
                }
                .padding()
                BottomNavigation()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension PayToMerchantView {
    var SenderDetailsView: some View {
        HStack(alignment: .top) {
            Image("dummy-man")
                .resizable()
                .frame(width: 50, height: 50)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("STUFFRS, S.A.")
                    Text("PANAMA")
                    Text("MID: 00000000000000096")
                    Text("TID: 00000096")
                }
                .foregroundStyle(.appBlue)
                .font(AppFonts.regularSixteen)
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
    
    var AmountToTransferView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Amount to Transfer")
                .font(AppFonts.regularTwentyTwo)
            HStack {
                Text("$")
                    .font(AppFonts.bodyTwentyTwoBold)
                TextField("", text: self.$amount)
                    .onChange(of: amount) { newValue in
                        amount = Formatters.formatAmountInput(newValue)
                        print(newValue)
                    }
                    .placeholder(when: self.amount.isEmpty) {
                        Text("0.00")
                            .font(AppFonts.bodyTwentyTwoBold)
                            .foregroundColor(.appBlue)
                            .opacity(0.3)
                    }
                    .font(AppFonts.bodyTwentyTwoBold)
                    .foregroundColor(.appBlue)
                    .keyboardType(.numberPad)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.appBlueForeground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        }
    }
}

#Preview {
    PayToMerchantView(viewModel: .init())
}
