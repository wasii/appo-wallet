//
//  ChangeTransactionPinView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct ChangeTransactionPinView: View {
    @State private var oldPIN: [String] = Array(repeating: "", count: 6)
    @State private var newPIN: [String] = Array(repeating: "", count: 6)
    @State private var confirmPIN: [String] = Array(repeating: "", count: 6)
    
    
    @State private var oldPinSwitch: Bool = false
    @State private var createPinSwitch: Bool = false
    @State private var confirmPinSwitch: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Change Transaction Pin")
            
            Text("do not share your pin with anyone and keep it in a safe place.")
                .textCase(.uppercase)
                .foregroundStyle(Color.appOrange)
                .font(.title3)
                .fontWeight(.regular)
            
            VStack(spacing: 30) {
                HStack {
                    Text("Old Pin")
                        .foregroundStyle(Color.appBlue)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Enable")
                        .font(.system(size: 15))
                        .fontWeight(.regular)
                    Toggle("Enable", isOn: $oldPinSwitch)
                        .labelsHidden() // Hides the default label of the Toggle
                        .toggleStyle(SwitchToggleStyle(tint: .appBlue))
                }
                .padding(.top, 20)
                
                OTPInputView(otpDigits: $oldPIN)
                    .padding(.top, -40)
                
                
                HStack {
                    Text("New Pin")
                        .foregroundStyle(Color.appBlue)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Enable")
                        .font(.system(size: 15))
                        .fontWeight(.regular)
                    Toggle("Enable", isOn: $createPinSwitch)
                        .labelsHidden() // Hides the default label of the Toggle
                        .toggleStyle(SwitchToggleStyle(tint: .appBlue))
                }
                
                OTPInputView(otpDigits: $newPIN)
                    .padding(.top, -40)
                
                
                HStack {
                    Text("Confirm New Pin")
                        .foregroundStyle(Color.appBlue)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Enable")
                        .font(.system(size: 15))
                        .fontWeight(.regular)
                    Toggle("Enable", isOn: $confirmPinSwitch)
                        .labelsHidden() // Hides the default label of the Toggle
                        .toggleStyle(SwitchToggleStyle(tint: .appBlue))
                }
                
                OTPInputView(otpDigits: $confirmPIN)
                    .padding(.top, -40)
                
            }
            .frame(width: 300)
            .frame(maxWidth: .infinity, alignment: .center)
            
            
            Button {} label: {
                Text("Submit")
                    .customButtonStyle()
            }
            Spacer()
        }
        .padding()
        .background(Color.appBackground)
    }
}

#Preview {
    ChangeTransactionPinView()
}
