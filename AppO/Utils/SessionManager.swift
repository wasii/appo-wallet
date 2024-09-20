//
//  SessionManager.swift
//  AppO
//
//  Created by Abul Jaleel on 21/09/2024.
//


import Foundation

class SessionManager: ObservableObject {
    @Published var isCreatingAccount: Bool = false
    
    // Singleton instance
    static let shared = SessionManager()
    
    // Private initializer to prevent multiple instances
    init() {}
    
    func logout() {
        DispatchQueue.main.async {
            AppDefaults.clearUserDefaults()
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        }
    }
    
    func resetSession() {
        isCreatingAccount = false
    }
}
