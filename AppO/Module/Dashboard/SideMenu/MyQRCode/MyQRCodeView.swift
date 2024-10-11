//
//  MyQRCodeView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//
import SwiftUI

struct MyQRCodeView: View {
    @StateObject var viewModel: MyQRCodeViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(1)
            VStack(spacing: 20) {
                NavigationBarView(title: "My QR Code")
                ScrollView {
                    ForEach(AppDefaults.user?.cardList ?? [], id: \.self) { card in
                        VStack(spacing: 0) {
                            HStack {
                                Text("Card Status: ")
                                    .font(AppFonts.regularEighteen)
                                + Text(card.cardStatusDesc ?? "")
                                    .font(AppFonts.bodyEighteenBold)
                            }
                            .foregroundStyle(.appBlue)
                            ZStack {
                                Image(card.cardImage ?? "")
                                    .resizable()
                                    .frame(height: 220)
                                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 0)
                                    .onTapGesture {
                                        homeNavigator.navigate(to: .cardList(viewModel: .init(showQRDetails: true)))
                                    }
                                
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text(card.maskCardNum ?? "")
                                        .font(AppFonts.regularTwenty)
                                    Text("Expiry: \(String(describing: Formatters.convertDateToMonthYear(card.expDate ?? "") ?? "10/2027")) \(card.cardName ?? "ABCDEDF")")
                                        .font(AppFonts.bodyFourteenBold)
                                }
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                        }
                    }
                }
                Spacer()
                VStack(spacing: 10) {
                    QRCodeShowBalance(isShowPopup: $viewModel.isShowPopup)
                    QRCodeProfileDetail()
                    
                }
                .padding()
                
                BottomNavigation()
            }
            .edgesIgnoringSafeArea(.top)
            .background(Color.appBackground)
            .toolbar(.hidden, for: .navigationBar)
            .showError("Error", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
            .onReceive(viewModel.coordinatorState) { state in
                switch (state.state, state.transferable) {
                case (.showBalance, _):
                    break
                }
            }
            .onChange(of: viewModel.isShowPopup) { newValue in
                if newValue {
                    Task {
                        do {
                            try await viewModel.getCustomerAvailableBalance()
                        }
                    }
                }
            }
        }
    }
    
    var CardStatusView: some View {
        HStack {
            Text("Card Status: ")
                .font(AppFonts.regularEighteen)
            + Text("InActive")
                .font(AppFonts.bodyEighteenBold)
        }
        .foregroundStyle(.appBlue)
    }
}

#Preview {
    MyQRCodeView(viewModel: .init())
}



struct QRCodeImageView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("qr_code")
                .resizable()
                .frame(maxHeight: 200)
                .frame(maxWidth: 150)
                .padding()
            
            VStack {
                Text("Your personal AppO QR ID.")
                Text("Show this QR to verify your identity.")
            }
            .font(AppFonts.regularFourteen)
            .foregroundStyle(.appBlue)
            
            HStack {
                Text("🇮🇳")
                    .font(.title)
                Text("India")
                Text("+91")
            }
            .foregroundStyle(.appBlue)
            .font(AppFonts.regular4)
            .font(.title2)
            .padding(.top, 5)
            
            Spacer()
        }
        .frame(maxWidth: 240)
        .frame(height: 280)
        .background(.appBlueForeground)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.appBlue, lineWidth: 1)
        )
        .frame(maxWidth: .infinity, alignment: .center)
    }
}


struct QRCodeShowBalance: View {
    @Binding var isShowPopup: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Available Balance")
                    .font(AppFonts.bodyTwentyBold)
                    .foregroundStyle(.appBlue)
                Toggle("", isOn: $isShowPopup)
                    .toggleStyle(CustomToggleStyle())
                    .labelsHidden()
                Spacer()
            }
        }
        .padding()
        .background(.appBlueForeground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
}

struct QRCodeProfileDetail: View {
    var body: some View {
        VStack {
            HStack {
                Image("accountant")
                    .resizable()
                    .frame(width: 25, height: 25)
                
                Text("Profile Details")
                    .font(AppFonts.bodyTwentyBold)
                    .padding(.leading, 15)
                    .foregroundStyle(.appBlue)
                
                Spacer()
                Button {} label: {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 13, height: 20)
                        .foregroundStyle(.appBlue)
                }
            }
        }
        .padding()
        .background(.appBlueForeground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.appBlue, lineWidth: 1)
        )
    }
}
