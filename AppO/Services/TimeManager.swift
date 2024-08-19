//
//  TimeManager.swift
//  AppO
//
//  Created by Abul Jaleel on 19/08/2024.
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int = 60
    @Published var isTimerComplete: Bool = false
    private var timer: Timer?
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimer() {
        timeRemaining = 60 // Reset timer to 1 minute
        isTimerComplete = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timeRemaining = 0
                self.isTimerComplete = true
                timer.invalidate()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func resetTimer() {
        stopTimer()
        startTimer()
    }
}
