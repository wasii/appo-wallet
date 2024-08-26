//
//  View+Extension.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func cardStyle(backgroundColor: Color = .white, cornerRadius: CGFloat = 10, height: CGFloat = 90) -> some View {
        self.modifier(CardStyle(backgroundColor: backgroundColor, cornerRadius: cornerRadius, height: height))
    }
}
