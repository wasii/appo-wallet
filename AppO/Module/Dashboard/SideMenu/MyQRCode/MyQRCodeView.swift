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
        VStack(spacing: 20) {
            NavigationBarView(title: "My QR Code")
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    QRCodeImageView()
                    
                    QRCodeShowBalance()
                    
                    QRCodeProfileDetail()
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Button {
            } label: {
                Text("SUBMIT")
                    .font(AppFonts.bodyEighteenBold)
                    .frame(width: 190, height: 45)
                    .background(Color.appBlue)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
            }
            BottomNavigation()
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
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
                .frame(maxHeight: 250)
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
        .frame(maxWidth: 300)
        .frame(height: 350)
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
    @State private var isShow: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Text("Available Balance")
                    .font(AppFonts.bodyTwentyBold)
                    .foregroundStyle(.appBlue)
                Toggle("", isOn: $isShow)
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
