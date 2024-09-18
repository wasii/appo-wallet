//
//  LoaderView.swift
//  AppO
//
//  Created by Abul Jaleel on 18/09/2024.
//

import Foundation
import SwiftUI

struct LoaderView: View {
    @Binding var showLoader: Bool
    
    var body: some View {
        ZStack {
            if showLoader{
                Color(.black.withAlphaComponent(0.3))
            }
            VStack {
                if showLoader {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2.5)
                    Spacer()
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: showLoader)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LoaderView(showLoader: .constant(true))
}
