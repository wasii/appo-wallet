//
//  CustomButtonStyle.swift
//  AppO
//
//  Created by Abul Jaleel on 27/08/2024.
//

import SwiftUI

struct CustomButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppFonts.headline4)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.appBlue)
            .cornerRadius(10)
            .foregroundColor(.white)
    }
}
