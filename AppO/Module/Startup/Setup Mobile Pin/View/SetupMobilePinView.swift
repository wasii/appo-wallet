//
//  SetupMobilePinView.swift
//  AppO
//
//  Created by Abul Jaleel on 19/08/2024.
//

import SwiftUI

struct SetupMobilePinView: View {
    
    @StateObject var viewModel: SetupMobilePinViewModel
    @EnvironmentObject var navigator: Navigator
    
    @State private var createPIN: [String] = Array(repeating: "", count: 6)
    @State private var confirmPIN: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Mobile Pin")
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Create Mobile Pin")
                    .padding(.top, 20)
                    .padding(.leading, 40)
                    .font(.headline)
                    .fontWeight(.bold)
                OTPInputView(otpDigits: $createPIN)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Confirm Mobile Pin")
                    .padding(.top, 10)
                    .padding(.leading, 40)
                    .font(.headline)
                    .fontWeight(.bold)
                OTPInputView(otpDigits: $confirmPIN)
            }
            Button {
                AppEnvironment.shared.isLoggedIn = true
            } label: {
                Text("SUBMIT")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
//                    .background(isSubmitButtonEnabled ? Color.appBlue : Color.appBlue.opacity(0.5))
                    .background(Color.appBlue)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
//                    .disabled(!isSubmitButtonEnabled)
            }
            Spacer()
        }
        .padding()
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.appBackground)
    }
    
    private var isSubmitButtonEnabled: Bool {
        let areBothPINsFilled = createPIN.allSatisfy { !$0.isEmpty } && confirmPIN.allSatisfy { !$0.isEmpty }
        let areBothPINsIdentical = createPIN == confirmPIN
        
        return areBothPINsFilled && areBothPINsIdentical
    }
}

#Preview {
    SetupMobilePinView(viewModel: .init())
}
