// 
//  testView.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import SwiftUI

struct testView: View {
    @ObservedObject var viewModel: testViewModel
    
    var body: some View {
        VStack {
            Text("Hello World")
        }
        .disabled(viewModel.showLoader)
        .showError(viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
        .onReceive(viewModel.coordinatorState) { state in
            // Handle the received state
            switch (state.state, state.transferable) {
            default:
                break
            }
        }
    }
}

#Preview {
    testView(viewModel: .init())
}
