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
    
    init() {
        // Customize navigation bar appearance
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor.systemBlue // Set your desired color
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        
//        // Apply the appearance settings
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
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
