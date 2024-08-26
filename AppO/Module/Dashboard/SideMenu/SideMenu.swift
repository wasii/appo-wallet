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
    case home = 0
    case favorite
    case chat
    case profile
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .favorite:
            return "Favorite"
        case .chat:
            return "Chat"
        case .profile:
            return "Profile"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "home"
        case .favorite:
            return "favorite"
        case .chat:
            return "chat"
        case .profile:
            return "profile"
        }
    }
}
