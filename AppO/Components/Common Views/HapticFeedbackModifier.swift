//
//  HapticFeedbackModifier.swift
//  AppO
//
//  Created by Abul Jaleel on 23/09/2024.
//

import SwiftUI
struct HapticFeedbackModifier: ViewModifier {
    let style: UIImpactFeedbackGenerator.FeedbackStyle
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let impactFeedback = UIImpactFeedbackGenerator(style: style)
                impactFeedback.impactOccurred()
            }
    }
}
