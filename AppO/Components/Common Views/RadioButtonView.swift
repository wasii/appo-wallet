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
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "circle.fill" : "circle")
                    .foregroundColor(isSelected ? .appBlue : .gray)
                    .font(.system(size: 25))
                    .padding(.leading, 4)
                
                Text(label)
                    .foregroundColor(.black)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 5)
        }
        .buttonStyle(PlainButtonStyle()) // Removes the default button styling
    }
}
