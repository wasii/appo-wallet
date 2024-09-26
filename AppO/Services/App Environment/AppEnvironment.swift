//
//  AppEnvironment.swift
//
//  Created by Aqeel Ahmed on 25/04/2022.
//

import Foundation
import Combine

class AppEnvironment: ObservableObject {
    
    static let shared = AppEnvironment()
    
    var usesLocalAPIMocks = false
    @Published var isLoggedIn: Bool = false
    private init() {}
    
    private var timer: Timer?
    private var targetTime: Date?
    
    private var infoDictionary: [String: Any] {
        get {
            if let dictionary = Bundle.main.infoDictionary {
                return dictionary
            } else {
                fatalError("Relevant .plist file not found")
            }
        }
    }
    
    func getValue<T>(for key: PlistKey) -> T {
        return infoDictionary[key.rawValue] as! T
    }
    
    static subscript<T>(key: PlistKey) -> T {
        if let dictionary = Bundle.main.infoDictionary {
            return dictionary[key.rawValue] as! T
        } else {
            fatalError("Relevant .plist file not found")
        }
    }
}


extension AppEnvironment {
    func startTimer(with dateString: String) {
        let currentDate = Date()
        
        // 5 minute add karein
        targetTime = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)
        print("New Logout Time: \(targetTime!)")
        
        // Timer ko set karen jo targetTime par trigger kare
        if let targetTime = targetTime {
            let timeInterval = targetTime.timeIntervalSinceNow
            
            // Agar time interval positive hai, tabhi timer start karen
            if timeInterval > 0 {
                timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerFinished), userInfo: nil, repeats: false)
                print("Timer started for \(timeInterval) seconds.")
            } else {
                print("Target time is in the past.")
            }
        }
    }
    
    // Timer finish hone ke baad call hone wala method
    @objc private func timerFinished() {
        stopTimer()
        self.isLoggedIn = false
    }
    
    // Timer ko manually stop karne ke liye method
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
