//
//  Fonts+Extension.swift
//  AppO
//
//  Created by Abul Jaleel on 06/09/2024.
//

import SwiftUI

extension Font {
    /// Choose your font to set up
    /// - Parameters:
    ///   - font: Choose one of your font
    ///   - style: Make sure the style is available
    ///   - size: Use prepared sizes for your app
    ///   - isScaled: Check if your app accessibility prepared
    /// - Returns: Font ready to show
    static func customFont(
        font: CustomFonts = .glacialIndiffernce,
        style: CustomFontStyle,
        size: CGFloat,
        isScaled: Bool = true) -> Font {
            return .custom(font.rawValue + style.rawValue,
                           size: size)
        }
}
