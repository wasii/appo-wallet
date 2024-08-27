//
//  AppOApp.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

@main
struct AppOApp: App {
    @StateObject var session: AppEnvironment = AppEnvironment.shared
    var body: some Scene {
        WindowGroup {
            //            InitialView(navigator: .init())
            //            HomeScreenView(homeNavigator: .init(), presentSideMenu: .constant(false ))
            //            MainTabbedView()
            
            ZStack {
                if session.isLoggedIn {
                    MainTabbedView()
                        .transition(.move(edge: .trailing)) // Slide in from the right
                } else {
                    InitialView(navigator: .init())
                        .transition(.move(edge: .leading)) // Slide in from the left
                }
            }
            .animation(.easeInOut, value: session.isLoggedIn)
        }
        .environment(\.colorScheme, .light)
    }
}
