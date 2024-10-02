//
//  AddOnCardView.swift
//  AppO
//
//  Created by Abul Jaleel on 27/08/2024.
//

import SwiftUI

struct AddOnCardView: View {
    
    @StateObject var viewModel: AddOnCardViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    @State private var phoneNumber: String = ""
    @State private var nameOnCard: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    
    var walletTypes: [WalletCardType] {
        WalletCardType.allCases
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(1)
            VStack(alignment: .leading, spacing: 20) {
                NavigationBarView(title: "Add on Card")
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        WalletTypeView
                        CardView
                        mobileNumberView
                        nameOnTheCardView
                        emailIDView
                        addressView
                        Button {
                            viewModel.createNewCard { bool in
                                if bool {
                                    homeNavigator.navigateToRoot()
                                }
                            }
                        } label: {
                            Text("Submit")
                                .customButtonStyle()
                        }
                        .padding(.vertical, 40)
                    }
                    .padding(.horizontal)
                }
                Spacer()
                BottomNavigation()
            }
            .ignoresSafeArea(.keyboard)
            .edgesIgnoringSafeArea(.top)
            .toolbar(.hidden, for: .navigationBar)
            .showError("", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    viewModel.getCardList()
                }
                nameOnCard = AppDefaults.user?.custName ?? ""
                email = AppDefaults.user?.primaryMailAddr ?? ""
                address = AppDefaults.user?.addr1 ?? ""
            }
        }
    }
}

extension AddOnCardView {
    var WalletTypeView: some View {
        HStack {
            Spacer()
            ForEach(walletTypes, id: \.self) { wallet in
                HStack {
                    Text(wallet.title)
                }
                .foregroundStyle(viewModel.currentWallet == wallet ? .white : .appBlue)
                .padding()
                .frame(height: 40)
                .background(viewModel.currentWallet == wallet ? .appBlue : .gray.opacity(0.08))
                .cornerRadius(60)
                .onTapGesture {
                    withAnimation {
                        viewModel.currentWallet = wallet
                        viewModel.updateSelectedType()
                    }
                }
                Spacer()
            }
        }
    }
    
    var CardView: some View {
        ZStack {
            Image(viewModel.currentWallet?.imageName ?? "")
                .resizable()
                .frame(height: 220)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
            
            VStack(alignment: .leading) {
//                Spacer()
//                Text("6262 2303 5678 9010")
//                    .font(AppFonts.regularTwenty)
//                Text("Expiry: 10/2016 JOE CHURCO")
//                    .font(AppFonts.bodyFourteenBold)
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    
    var mobileNumberView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Mobile Number")
                .font(AppFonts.regularTwentyTwo)
            HStack {
                Text("IN")
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.black)
                Text("+91")
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.black)
                
                Image(systemName: "chevron.down")
                    .padding(.trailing, 5)
                    .foregroundStyle(Color.black)
                    .font(AppFonts.bodyEighteenBold)
                
                Text("\(AppDefaults.user?.primaryMobileNum ?? "")")
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.appBlue)
                    .offset(x: 20)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(10, corners: .allCorners)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.appBlueForeground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBlue, lineWidth: 1)
            )
        }
    }
    
    var nameOnTheCardView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Name on the Card")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $nameOnCard)
                .placeholder(when: nameOnCard.isEmpty) {
                    Text("Enter Last Name")
                        .font(AppFonts.bodyEighteenBold)
                        .foregroundColor(.appBlue)
                }
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
        .disabled(true)
    }
    
    var emailIDView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Email ID")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $email)
                .placeholder(when: email.isEmpty) {
                    Text("Enter Email ID")
                        .font(AppFonts.bodyEighteenBold)
                        .foregroundColor(.appBlue)
                }
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .keyboardType(.emailAddress)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
        .disabled(true)
    }
    
    var addressView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Address")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $address)
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .keyboardType(.default)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
        .disabled(true)
    }
}

#Preview {
    AddOnCardView(viewModel: .init())
}
