//
//  RadioButtonView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct RadioButtonField: View {
    var id: String
    var label: String
    var isSelected: Bool
    var labelColor: Color = .appBlue
    var labelFont:  Font = AppFonts.regularTwentyTwo
    var imageName: String = ""
    var action: () -> Void
    
    
    var body: some View {
        Button(action: action) {
            VStack {
                HStack(spacing: 10) {
                    Image(isSelected ? "radio-button-selected" : "radio-button")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .padding(.leading, 4)
                    
                    Text(label)
                        .foregroundColor(labelColor)
                        .font(labelFont)
                        .fontWeight(.semibold)
                    if !imageName.isEmpty {
                        Spacer()
                        Image(imageName)
                            .resizable()
                            .frame(width: 60)
                            .frame(height: 30)
                            .scaledToFit()
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .buttonStyle(PlainButtonStyle()) // Removes the default button styling
    }
}

#Preview {
    RadioButtonField(id: "", label: "Male", isSelected: false) {}
    
}
