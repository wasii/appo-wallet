//
//  AppLogoView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct AppLogoView: View {
    var body: some View {
        Image("app_logo")
            .resizable()
            .scaledToFit()
            .padding(.leading, 10)
    }
}

#Preview {
    AppLogoView()
}
