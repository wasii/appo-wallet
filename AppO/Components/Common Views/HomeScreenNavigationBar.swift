//
//  HomeScreenNavigationBar.swift
//  AppO
//
//  Created by Abul Jaleel on 09/09/2024.
//

import SwiftUI

struct HomeScreenNavigationBar: View {
    @Environment(\.dismiss) var dismiss
    var title: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.appBlue)
                .frame(height: 100)
                .cornerRadius(40, corners: [.bottomLeft, .bottomRight])
            HStack(spacing: 20) {
                Button(action: {
                    dismiss()
                }) {
                    Image("sidebar-menu")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                }
                Text(title)
                    .foregroundColor(.white)
                    .font(AppFonts.headline4)
                    .bold()
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    HomeScreenNavigationBar(title: "🇮🇳 India (IN)")
}
