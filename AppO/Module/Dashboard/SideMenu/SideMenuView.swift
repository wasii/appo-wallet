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
    case payments
    case settings
}

struct SideMenuView: View {
    @EnvironmentObject var homeNavigator: HomeNavigator
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    
    var closure: ((SidemenuNavigation)->())
    
    var body: some View {
        HStack {
            ZStack{
                VStack(alignment: .leading, spacing: 0) {
                    ProfileImageView()
                        .frame(height: 30)
                        .padding(.leading, 10)
                        .padding(.bottom, 50)
                        .padding(.top, 60)
                    
                    TopHeaderNavigation()
                        .padding(.leading, 10)
                        .padding(.bottom, 30)
                    
                    ForEach(SideMenuRowType.allCases, id: \.self){ row in
                        RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                            self.navigateToView(index: row.rawValue)
                        }
                    }
                    .padding(.leading, 10)
                    
                    
                    Text("App Version: 1.0.0")
                        .padding(.leading, 10)
                        .padding(.top, 50)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .frame(width: 290)
                .background(
                    Color.white
                )
            }
            Spacer()
        }
        .background(.clear)
    }
    
    func ProfileImageView() -> some View {
        HStack {
            Image("user_profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Text("username")
                Spacer()
                Text("user mobile number")
            }
            .fontWeight(.semibold)
        }
    }
    
    func TopHeaderNavigation() -> some View {
        HStack {
            ForEach(sideMenuTopNavigator, id: \.self) { item in
                Button {} label: {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color.appYellow)
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: item.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                        Text(item.title)
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
    
    
    
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 10){
                    ZStack{
                        Circle()
                            .fill(Color.appYellow)
                            .frame(width: 40, height: 40)
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 17)
                            .foregroundColor(.white)
                    }
                    .frame(width: 40, height: 40)
                    Text(title)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.black)
                    Spacer()
                }
                Divider()
            }
        }
        .frame(height: 60)
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
            closure(.payments)
        case 4:
            closure(.settings)
        default: break
        }
    }
}

#Preview {
    SideMenuView(selectedSideMenuTab: .constant(0), presentSideMenu: .constant(true), closure: { _ in })
        .environmentObject(HomeNavigator())
}
