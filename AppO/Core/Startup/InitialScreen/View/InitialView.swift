//
//  InitialView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct InitialView: View {
    var body: some View {
        NavigationStack {
            
            VStack {
                ScrollView {
                    VStack(spacing: 25) {
                        Spacer()
                        AppLogoView()
                        
                        Text("WELCOME")
                            .foregroundStyle(Color(.appBlue))
                            .font(.largeTitle)
                        
                        Image("image_splash")
                            .resizable()
                            .frame(width: 250, height: 220)
                        
                        Image("appopay_qr")
                            .resizable()
                            .frame(width: 120, height: 120)
                        
                        NavigationLink(destination: TermAndConditionView()) {
                            Text("Get Started")
                                .font(.title3)
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.width / 1.7)
                                .frame(height: 60)
                                .background(Color(.appBlue))
                                .clipShape(Capsule())
                                .foregroundStyle(Color.white)
                        }
                        
                    }
                    .padding(.bottom)
                }
                .padding(.top)
                BottomNavigation()
            }
            .background(.appBackground)
        }
    }
}

#Preview {
    InitialView()
}
