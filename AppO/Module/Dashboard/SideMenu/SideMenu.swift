//
//  SideMenu.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct SideMenu: View {
    @Binding var isShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(
                        Color.clear
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

#Preview {
    SideMenu(isShowing: .constant(true), content: AnyView(Text("Content Placeholder")))
}


enum SideMenuRowType: Int, CaseIterable{
    case manageAccount = 0
    case myQrCode
    case cardToCard
    case payments
    case settings
    
    var title: String{
        switch self {
        case .manageAccount:
            return "Manage Account"
        case .myQrCode:
            return "My Qr-Code"
        case .cardToCard:
            return "Card To Card"
        case .payments:
            return "Payments"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String{
        switch self {
        case .manageAccount:
            return "person.circle"
        case .myQrCode:
            return "favorite"
        case .cardToCard:
            return "creditcard"
        case .payments:
            return "dollarsign"
        case .settings:
            return "settings"
        }
    }
}
