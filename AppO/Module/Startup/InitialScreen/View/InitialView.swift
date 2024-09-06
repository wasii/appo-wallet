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
                        .frame(width: 320)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .background(Color.appBlue)
                Spacer()
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
