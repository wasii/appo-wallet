//
//  NavigationBarView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct NavigationBarView: View {
    @Environment(\.dismiss) var dismiss
    var title: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.appBlue)
                .frame(height: 100)
                .cornerRadius(40, corners: [.bottomLeft, .bottomRight])
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("back-new")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 18, height: 30)
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
    NavigationBarView(title: "Terms and Condition")
}

