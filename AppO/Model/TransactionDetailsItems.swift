//
//  TransactionDetailsItems.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation

struct TransactionDetailsItems: Identifiable, Hashable {
    var id: UUID = .init()
    var dateTime: String
    var details: String
    var price: String
}

var transactionDetailsItems: [TransactionDetailsItems] = [
    TransactionDetailsItems(dateTime: "14-Aug-2024 10:46:18", details: "purchases in restaurant", price: "100.00 Dr"),
    TransactionDetailsItems(dateTime: "13-Aug-2024 08:12:51", details: "purchases in hotel", price: "200.00 Dr"),
    TransactionDetailsItems(dateTime: "13-Aug-2024 12:06:48", details: "purchases in grocery store", price: "250.00 Dr"),
    TransactionDetailsItems(dateTime: "12-Aug-2024 16:40:28", details: "purchases in grocery store", price: "50.00 Dr"),
]
