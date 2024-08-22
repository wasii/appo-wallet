//
//  NavigationBarView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct NavigationBarView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isOn: Bool = false
    var title: String
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 23)
                        .fill(.backButton) // Background for the image
                        .frame(width: 46, height: 46)
                    
                    Image("back")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            Text(title)
                .font(.title2)
            
            Spacer()
            
//            HStack(spacing: 18) {
//                Text("Enable")
//                    .foregroundStyle(Color.gray)
//                    .font(.title3)
//                Toggle(isOn: $isOn) {}
//            }
//            .padding()
        }
    }
}

#Preview {
    NavigationBarView(title: "Sample Text")
}
