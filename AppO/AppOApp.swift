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
            
            if session.isLoggedIn {
                MainTabbedView()
            } else {
                InitialView(navigator: .init())
            }
        }
        .environment(\.colorScheme, .light)
    }
}
