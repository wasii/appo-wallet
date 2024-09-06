//
//  InitialView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct InitialView: View {
    @StateObject var navigator: Navigator
    var body: some View {
        NavigationStack(path: $navigator.navPath) {
            VStack {
                VStack(alignment: .center) {
                    Image("appopay-new")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                    
                    Image("welcome-screen-person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .background(Color.appBlue)
                
                Text("WELCOME")
                    .font(AppFonts.headline1)
                
                Image("qr-code")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .offset(y: -20)
                
                Button {
                    navigator.navigate(to: .termsAndConditionView)
                } label: {
                    Text("Get Started")
                        .font(AppFonts.bodyEighteenBold)
                        .frame(width: 150, height: 60)
                        .background(Color.appBlue)
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                        .offset(y: -20)
                }
                Spacer()
                Text("Bottom View")
            }
            
            .navigationDestination(for: Navigator.Destination.self) { destination in
                navigator.view(for: destination)
            }
        }
        .environmentObject(navigator)
    }
}

#Preview {
    InitialView(navigator: .init())
}
