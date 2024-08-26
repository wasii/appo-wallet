//
//  SideMenuTopNavigator.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import Foundation
struct SideMenuTopNavigator: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var icon: String
}

var sideMenuTopNavigator: [SideMenuTopNavigator] = [
    SideMenuTopNavigator(title: "Deposit", icon: "plus"),
    SideMenuTopNavigator(title: "Withdraw", icon: "arrow.down"),
    SideMenuTopNavigator(title: "Send", icon: "arrow.right"),
    SideMenuTopNavigator(title: "My Cards", icon: "creditcard")
]
