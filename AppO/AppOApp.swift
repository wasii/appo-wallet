//
//  AppOApp.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseMessaging
import BlinkID

@main
struct AppOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var sessionManager: SessionManager = SessionManager.shared
    @StateObject var session: AppEnvironment = AppEnvironment.shared
    init() {
        AppDefaults.temp_card = nil
        AppDefaults.dek = nil
        AppDefaults.dek_kcv = nil
        AppDefaults.dmk = nil
        AppDefaults.dmk_kcv = nil
        AppDefaults.user = nil
        AppDefaults.newUser = nil
        AppDefaults.temp_scan_code = nil
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if session.isLoggedIn {
                    MainTabbedView()
                        .transition(.move(edge: .bottom)) // Slide in from the right
                } else {
                    InitialView(navigator: .init())
                        .transition(.move(edge: .top)) // Slide in from the left
                }
            }
            .animation(.spring, value: session.isLoggedIn)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        MBMicroblinkSDK.shared().setLicenseKey("sRwCABpjb20uYXBwb3BheS5hcHBvcGF5LndhbGxldAFsZXlKRGNtVmhkR1ZrVDI0aU9qRTNNamMzTmpNek9EQXhNakFzSWtOeVpXRjBaV1JHYjNJaU9pSm1abVJoT1dFMU15MDFaalZsTFRRMFl6a3RZbUV4WXkxallqYzBZemt6T0RZeE0ySWlmUT09Kd2wrLNlqOzS6LZzInkItPZSrB3QKdhUISms3WSEGGGdgG0FgGJPLThQv+V1Yr5zqU/2i+V+PYzsbM1S0Xld/YGjSuDVjWItcxkvKSKg5JeUcK6CULM2Y8juDnWgdcHzX8eYQe+dD3xvs2LTtLKb7pfeC8b+Z6yg") { error in
            print(error)
        }
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
            guard success else {
                return
            }
            print("SUCCESS")
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().token() { token, error in
            if let error {
                print("Error fetching FCM Registration Token: \(error)")
            } else if let token {
                print("FCM Registration Token: \(token)")
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Oh no! Failed to register for remote notification with error: \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var readableToken = ""
        for index in 0..<deviceToken.count {
            readableToken += String(format: "%02.2hhx", deviceToken[index] as CVarArg)
        }
        print("Received an APNs Device Token: \(readableToken)")
    }
}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase Token: \(String(describing: fcmToken))")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .list, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil, userInfo: userInfo)
        completionHandler()
    }
}
