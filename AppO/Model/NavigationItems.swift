//
//  NavigationItems.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import Foundation
struct NavigationItems: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var icon: String
}

var navigationItems: [NavigationItems] = [
    NavigationItems(title: "", icon: "visa"),
    NavigationItems(title: "", icon: "unionpay-highresolution"),
    NavigationItems(title: "", icon: "union-pay"),
    NavigationItems(title: "", icon: "quick-pass")
]
