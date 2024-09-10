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
    
    @State private var isMasked: Bool = true
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView(title: "Manage Account")
            VStack(spacing: 20) {
                maskedUnMaskedView
                textualView
                ScrollView(.vertical) {
                    CardView
                    AppoPayUnionCard
                    AppoPayVisaCard
                }
                .scrollIndicators(.hidden)
                .onTapGesture {
                    homeNavigator.navigate(to: .transactionsDetails(viewModel: .init()))
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            Spacer()
            
            BottomNavigation()
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension ManageAccountView {
    var maskedUnMaskedView: some View {
        HStack {
            Text("Mask")
                .foregroundColor(.appBlue)
                .font(isMasked ? AppFonts.bodyTwentyTwoBold : AppFonts.regularTwentyTwo)
            
            Toggle("", isOn: $isMasked)
                .toggleStyle(CustomToggleStyle())
                .labelsHidden()
            
            Text("UnMask")
                .foregroundColor(.appBlue)
                .font(isMasked ? AppFonts.regularTwentyTwo : AppFonts.bodyTwentyTwoBold)
        }
    }
    
    var textualView: some View {
        VStack(spacing: 5) {
            Text("Tap on Card to see last 10 transactions")
                .font(AppFonts.bodyTwentyBold)
            HStack {
                Text("Card Status:")
                    .font(AppFonts.regularTwenty)
                Text("FirstIssue Card")
                    .font(AppFonts.bodyTwentyBold)
            }
            
        }
        .foregroundStyle(.appBlue)
    }
    
    var CardView: some View {
        ZStack(alignment: .top) {
            Image("appo-pay-card")
                .resizable()
                .frame(height: 220)
            
            VStack(alignment: .leading) {
                Spacer()
                Text(isMasked ? "6262 2303 **** ****" : "6262 2303 5678 9010")
                    .font(AppFonts.regularTwenty)
                Text("Expiry: 10/2016 JOE CHURCO")
                    .font(AppFonts.bodyFourteenBold)
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 220)
        }
    }
    
    var AppoPayUnionCard: some View {
        ZStack(alignment: .top) {
            Image(isMasked ? "appopay-unionpay-card" : "appopay-unionpay-card-visible")
                .resizable()
                .frame(height: 220)
        }
    }
    
    var AppoPayVisaCard: some View {
        ZStack(alignment: .top) {
            Image("appopay-visa-card")
                .resizable()
                .frame(height: 220)
            
            VStack(alignment: .leading) {
                Spacer()
                Text(isMasked ? "**** 5679" : "5354 5679")
                    .font(AppFonts.regularTwenty)
            }
            .foregroundStyle(.appBlue)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 220)
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color.gray : .appBlue)
                .frame(width: 60, height: 30)
                .overlay(
                    Image(systemName: "pause.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .offset(x: configuration.isOn ? -15 : 15)
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}



#Preview {
    ManageAccountView(viewModel: .init())
}
