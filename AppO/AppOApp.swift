//
//  AppOApp.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

@main
struct AppOApp: App {
    var body: some Scene {
        WindowGroup {
            InitialView(navigator: .init())
//            HomeScreenView(homeNavigator: .init(), presentSideMenu: .constant(false ))
            MainTabbedView()
        }
        .environment(\.colorScheme, .light)
    }
}
