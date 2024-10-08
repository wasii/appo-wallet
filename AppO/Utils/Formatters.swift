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
}
