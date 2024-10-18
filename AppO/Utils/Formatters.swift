//
//  Formatters.swift
//  AppO
//
//  Created by Abul Jaleel on 08/10/2024.
//

import Foundation


class Formatters {
    init() {}
    
    static func formatCreditCardNumber(_ number: String) -> String {
        let trimmedString = number.replacingOccurrences(of: " ", with: "")
        var formattedString = ""
        for (index, character) in trimmedString.enumerated() {
            if index != 0 && index % 4 == 0 {
                formattedString.append(" ")
            }
            formattedString.append(character)
        }
        return formattedString
    }
    static func convertDateToMonthYear(_ date: String) -> String? {
        guard date.count == 8 else {
            return nil
        }
        let startIndex = date.index(date.startIndex, offsetBy: 2)
        let endIndex = date.index(date.startIndex, offsetBy: 4)
        
        let month = String(date[startIndex..<endIndex])
        let year = String(date.suffix(4))
        
        
        return "\(month)/\(year)"
    }
    
    static func formatDateTime(_ date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        
        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let formattedDateString = dateFormatter.string(from: date)
            return formattedDateString
        }
        return nil
    }
    
    static func formatTime(_ time: String) -> String? {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HHmmss"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let time = timeFormatter.date(from: time) {
            timeFormatter.dateFormat = "hh:mm:ss a"
            let formattedTimeString = timeFormatter.string(from: time)
            
            return formattedTimeString
        }
        return nil
    }
    
    static func formatAmountInput(_ input: String) -> String {
        let filtered = input.filter { $0.isNumber }
        if let number = Double(filtered) {
            let formattedNumber = number / 100
            return String(format: "%.2f", formattedNumber)
        }
        return ""
    }
}
