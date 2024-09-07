//
//  BottomNavigation.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct BottomNavigation: View {
    
    var body: some View {
        GeometryReader { geometry in
            HStack() {
                ForEach(navigationItems, id: \.self) { item in
                    HStack {
                        Image(item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color.appBlue)
            .cornerRadius(25, corners: [.allCorners])
            .padding(.horizontal)
        }
        .frame(height: 60)
    }
}

#Preview {
    BottomNavigation()
}
