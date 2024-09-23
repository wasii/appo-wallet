//
//  AppOApp.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

@main
struct AppOApp: App {
    
    @State var sessionManager: SessionManager = SessionManager.shared
    @StateObject var session: AppEnvironment = AppEnvironment.shared
    init() {}
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if session.isLoggedIn {
                    MainTabbedView()
                        .transition(.move(edge: .trailing)) // Slide in from the right
                } else {
                    InitialView(navigator: .init())
                        .transition(.move(edge: .leading)) // Slide in from the left
                }
//                if session.isLoggedIn {
//                    MainTabbedView()
//                        .transition(.move(edge: .trailing)) // Slide in from the right
//                } else {
//                    InitialView(navigator: .init())
//                        .transition(.move(edge: .leading)) // Slide in from the left
//                }
            }
            .animation(.easeInOut, value: AppDefaults.isLogin)
        }
    }
}
