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
    NavigationItems(title: "", icon: "bottom_logo_visa"),
    NavigationItems(title: "", icon: "bottom_logo_union"),
    NavigationItems(title: "", icon: "bottom_logo_unionpay"),
    NavigationItems(title: "", icon: "bottom_logo_quickpass")
]
