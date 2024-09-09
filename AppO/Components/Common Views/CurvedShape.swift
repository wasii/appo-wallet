//
//  CurvedShape.swift
//  AppO
//
//  Created by Abul Jaleel on 09/09/2024.
//

import SwiftUI

struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
            var path = Path()
            
            // Start from the top left
            path.move(to: CGPoint(x: 0, y: 0))
            
            // Draw straight line to the top-right corner
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
            // Draw curve for the bottom area
            path.addQuadCurve(
                to: CGPoint(x: 0, y: rect.height * 0.35),
                control: CGPoint(x: rect.width / 1.2, y: rect.height * 1.15)
            )
            
            // Close the shape
            path.addLine(to: CGPoint(x: 0, y: 0))
            
            return path
        }
}

#Preview {
    CurvedShape()
}
