//
//  String+Extensions.swift
//  AppO
//
//  Created by Abul Jaleel on 10/10/2024.
//

import Foundation

extension String {
    func parseTransactions() -> [Transaction] {
        let lines = self.components(separatedBy: "\n")
        var transactions = [Transaction]()
        
        
        for line in lines {
            let components = line.split(separator: " ").map { String($0) }
            
            if components.count >= 6 {
                let date = components[0]
                let time = components[1]
                let detail = components[2] + " " + components[3] // Transaction detail
                let amount = components[4] + " " + components[5] // Amount (e.g., 10.00 CR or 10.00 DR)
                
                // Create a Transaction object
                let transaction = Transaction(date: date, time: time, detail: detail, amount: amount)
                
                // Add it to the list of transactions
                transactions.append(transaction)
            }
        }
        return transactions
    }
}
