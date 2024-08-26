//
//  HomeScreenView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject var homeNavigator: HomeNavigator
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        NavigationStack(path: $homeNavigator.navPath) {
            VStack(alignment: .leading, spacing: 20) {
                CardButtonView(cardType: "Visa Gold Card", cardNumber: "423671******0129" ,cardExpiry: "01/30")
                
                Text("Services")
                    .font(.title2)
                    .foregroundStyle(Color.black.opacity(0.7))
                
                HStack(spacing: 20) {
                    ForEach(navigationItems, id: \.self) { item in
                        HStack {
                            if !item.icon.isEmpty {
                                Button {} label: {
                                    Image(item.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                        .padding()
                        .background(.white)
                        .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            .toolbarBackground(Color.appBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button{
                            presentSideMenu.toggle()
                        } label: {
                            Image("menu_left")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .background(
                                    RoundedRectangle(cornerRadius: 23)
                                        .fill(.white)
                                        .frame(width: 46, height: 46)
                                )
                        }
                        Text("India (IN)")
                            .font(.title2)
                            .foregroundStyle(Color.white)
                            .padding(.leading, 5)
                    }
                    .padding(.leading, 5)
                    .padding(.bottom, 15)
                }
            }
            .padding()
            .background(Color.appBackground)
            .navigationDestination(for: HomeNavigator.Destination.self) { destination in
                homeNavigator.view(for: destination)
            }
        }
        .environmentObject(homeNavigator)
    }
}

#Preview {
    HomeScreenView(homeNavigator: .init(), presentSideMenu: .constant(true))
}
