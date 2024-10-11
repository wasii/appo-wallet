//
//  SideMenuView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

enum SidemenuNavigation {
    case manageAccount
    case myQrCode
    case cardToCard
    case settings
    case changeLanguage
    case logout
}

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var homeNavigator: HomeNavigator
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    
    var closure: ((SidemenuNavigation)->())
    
    var body: some View {
        ZStack {
            if presentSideMenu {
                // Background Blur when side menu is open
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 10)
                    .onTapGesture {
                        presentSideMenu.toggle()
                    }
            }
            
            HStack {
                // Side Menu (80% of the screen width)
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image("user-top-icon")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Joe")
                                .font(AppFonts.bodyTwentyTwoBold)
                                .bold()
                                .foregroundColor(.white)
                            Text("0987654321")
                                .foregroundColor(.white)
                                .font(AppFonts.regularEighteen)
                        }
                        Spacer()
                        Button(action: {
                            presentSideMenu.toggle()
                        }) {
                            Image("close-top-icon")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.white)
                        .padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        MenuButtonView(icon: "deposit-top-icon", text: "Deposit")
                        MenuButtonView(icon: "withdraw-top-icon", text: "Withdraw")
                        MenuButtonView(icon: "send-top-icon", text: "Send")
                        MenuButtonView(icon: "mycard-top-icon", text: "My Card")
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer().frame(height: 0)
                    
                    SidebarOption(icon: "manage-account-icon", title: "Manage Account")
                        .onTapGesture {
                            selectedSideMenuTab = 0
                            presentSideMenu.toggle()
                            navigateToView(index: 0)
                        }
                    SidebarOption(icon: "myqrcod-icon", title: "My QR-Code")
                        .onTapGesture {
                            selectedSideMenuTab = 1
                            presentSideMenu.toggle()
                            navigateToView(index: 1)
                        }
                    SidebarOption(icon: "card-to-card-icon", title: "Card To Card")
                        .onTapGesture {
                            selectedSideMenuTab = 2
                            presentSideMenu.toggle()
                            navigateToView(index: 2)
                        }
                    SidebarOption(icon: "settings-icon", title: "Settings")
                        .onTapGesture {
                            selectedSideMenuTab = 3
                            presentSideMenu.toggle()
                            navigateToView(index: 3)
                    }
                    
                    SidebarOption(icon: "payment-icon", title: "Change Language")
                        .onTapGesture {
                            selectedSideMenuTab = 4
                            presentSideMenu.toggle()
                            navigateToView(index: 5)
                        }
                    
                    SidebarOption(icon: "logout-icon", title: "Logout")
                        .onTapGesture {
                            selectedSideMenuTab = 5
                            presentSideMenu.toggle()
                            navigateToView(index: 5)
                        }
                    Spacer()
                    
                    Text("App Version: 1.0")
                        .font(AppFonts.regularTwentyTwo)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 40)
                .frame(width: UIScreen.main.bounds.width * 0.8) // 80% of screen width
                .background(Color.appBlue)
                .edgesIgnoringSafeArea(.bottom)
                .cornerRadius(20, corners: [.topRight, .bottomRight])
                Spacer() // To push the menu from the left side
            }
        }
    }
    
    fileprivate func navigateToView(index: Int) {
        switch index {
        case 0:
            closure(.manageAccount)
        case 1:
            closure(.myQrCode)
        case 2:
            closure(.cardToCard)
        case 3:
            closure(.settings)
        case 4:
            closure(.changeLanguage)
        case 5:
            closure(.logout)
        default: break
        }
    }
}

struct MenuButtonView: View {
    var icon: String
    var text: String
    
    var body: some View {
        VStack {
            Image(icon)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
            Text(text)
                .font(AppFonts.regularSixteen)
                .foregroundColor(.white)
        }
    }
}

struct SidebarOption: View {
    var icon: String
    var title: String
    
    var body: some View {
        HStack {
            HStack {
                Spacer()
                Image(icon)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.appBlueForeground)
            .cornerRadius(20, corners: [.topRight, .bottomRight])
            .frame(width: 130, height: 50)
            
            Text(title)
                .foregroundColor(.white)
                .font(AppFonts.regularTwentyTwo)
        }
    }
}

struct ContentView: View {
    @State private var presentSideMenu = false
    @State private var selectedSideMenuTab = 0
    
    var body: some View {
        ZStack {
            // Main Content
            VStack {
                Text("Main Content View")
                    .font(.largeTitle)
                
                Button("Open Side Menu") {
                    presentSideMenu = true
                }
            }
            
            // Side Menu
            if presentSideMenu {
                SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu, closure: { _ in })
                    .environmentObject(HomeNavigator())
                    .transition(.move(edge: .leading))
            }
        }
    }
}

#Preview {
    SideMenuView(selectedSideMenuTab: .constant(0), presentSideMenu: .constant(true), closure: { _ in })
        .environmentObject(HomeNavigator())
}
