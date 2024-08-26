//
//  CustomTextfieldStyle.swift
//  AppO
//
//  Created by Abul Jaleel on 27/08/2024.
//

import SwiftUI

struct CustomTextfieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .frame(height: 57)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}
