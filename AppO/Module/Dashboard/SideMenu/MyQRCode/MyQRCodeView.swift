//
//  MyQRCodeView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//
import SwiftUI

struct MyQRCodeView: View {
    var body: some View {
        VStack(spacing: 20) {
            NavigationBarView(title: "")
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    QRCodeImageView()
                    
                    QRCodeShowBalance()
                    
                    QRCodeProfileDetail()
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.appBackground)
    }
}

#Preview {
    MyQRCodeView()
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
            .font(.footnote)
            
            HStack {
                Text("🇮🇳")
                    .font(.title)
                Text("India")
                Text("+91")
            }
            .font(.title2)
            .padding(.top, 10)
            
            Spacer()
        }
        .frame(maxWidth: 300)
        .frame(height: 390)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .frame(maxWidth: .infinity, alignment: .center)
    }
}


struct QRCodeShowBalance: View {
    var body: some View {
        VStack {
            HStack {
                Text("Available Balance")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.gray)
                Text("👁️")
                Spacer()
                
                Button {} label: {
                    Text("Show")
                        .foregroundStyle(Color.black)
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct QRCodeProfileDetail: View {
    var body: some View {
        VStack {
            HStack {
                Image("user_profile")
                    .resizable()
                    .frame(width: 45, height: 45)
                
                Text("Profile Details")
                    .font(.title2)
                    .padding(.leading, 15)
                
                Spacer()
                Button {} label: {
                    Image("forword_track")
                        .resizable()
                        .frame(width: 25, height: 20)
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
