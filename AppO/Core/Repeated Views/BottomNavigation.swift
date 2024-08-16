//
//  BottomNavigation.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct BottomNavigation: View {
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(navigationItems, id: \.self) { item in
                HStack {
                    if !item.icon.isEmpty {
                        Image(item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding()
                .background(.white)
                .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    BottomNavigation()
}
