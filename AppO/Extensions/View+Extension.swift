//
//  View+Extension.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation
import SwiftUI

extension View {
    func showError(
        _ title: String = "Error",
        _ error: String?,
        isPresenting: Binding<Bool>,
        onTap: (() -> ())? = nil) -> some View {
        
        self.modifier(
            AlertPresentationModifier(isPresented: isPresenting, title: title, message: error ?? "", dismissButtonTitle: "Dismiss", action: onTap)
        )
    }
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
    
    func customTextfieldStyle() -> some View {
        self.modifier(CustomTextfieldStyle())
    }
    
    func customButtonStyle() -> some View {
        self.modifier(CustomButtonStyle())
    }
    
    func customButtonStyleWithBordered() -> some View {
        self.modifier(CustomButtonStyleBordered())
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func lightHaptic() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    func mediumHaptic() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    func heavyHaptic() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct AlertPresentationModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let dismissButtonTitle: String
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content.alert(isPresented: $isPresented) {
            Alert(title: Text(title), message: Text(message), dismissButton: .default(Text(dismissButtonTitle)) {
                action?()
            })
        }
    }
}
