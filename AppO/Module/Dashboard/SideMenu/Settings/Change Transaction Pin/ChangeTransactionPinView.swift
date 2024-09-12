//
//  ChangeTransactionPinView.swift
//  AppO
//
//  Created by Abul Jaleel on 26/08/2024.
//

import SwiftUI

struct ChangeTransactionPinView: View {
    
    @StateObject var viewModel: ChangeTransactionPinViewModel
    @EnvironmentObject var homeNavigator: HomeNavigator
    
    @State private var oldPIN: [String] = Array(repeating: "", count: 6)
    @State private var newPIN: [String] = Array(repeating: "", count: 6)
    @State private var confirmPIN: [String] = Array(repeating: "", count: 6)
    
    
    @State private var oldPinSwitch: Bool = false
    @State private var createPinSwitch: Bool = false
    @State private var confirmPinSwitch: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "Change Transaction Pin")
            
            VStack(alignment: .leading, spacing: 20) {
                Text("do not share your pin with anyone and keep it in a safe place.")
                    .textCase(.uppercase)
                    .foregroundStyle(.appBlue)
                    .font(AppFonts.regularTwenty)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack {
                    OldPinView
                    NewPinView
                    ConfirmPinView
                }
                .frame(width: 320)
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                Button {} label: {
                    Text("Submit")
                        .customButtonStyle()
                }
            }
            .padding()
            Spacer()
            
            BottomNavigation()
        }
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.top)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension ChangeTransactionPinView {
    var OldPinView: some View {
        VStack {
            HStack {
                Text("Old Pin")
                    .font(AppFonts.bodyTwentyBold)
                Spacer()
                Text("Enable")
                    .font(AppFonts.regularSixteen)
                
                Toggle("", isOn: $oldPinSwitch)
                    .toggleStyle(CustomToggleStyle())
                    .labelsHidden()
            }
            .foregroundStyle(Color.appBlue)
            .padding(.top, 20)
            
            OTPInputView(otpDigits: $oldPIN, isSecure: true)
                .padding(.top, -10)
        }
    }
    
    var NewPinView: some View {
        VStack {
            HStack {
                Text("New Pin")
                    .font(AppFonts.bodyTwentyBold)
                Spacer()
                Text("Enable")
                    .font(AppFonts.regularSixteen)
                Toggle("Enable", isOn: $createPinSwitch)
                    .toggleStyle(CustomToggleStyle())
                    .labelsHidden()
            }
            .foregroundStyle(Color.appBlue)
            .padding(.top, 20)
            
            OTPInputView(otpDigits: $newPIN, isSecure: true)
                .padding(.top, -10)
        }
    }
    
    var ConfirmPinView: some View {
        VStack {
            HStack {
                Text("Confirm New Pin")
                    .font(AppFonts.bodyTwentyBold)
                Spacer()
                Text("Enable")
                    .font(AppFonts.regularSixteen)
                Toggle("Enable", isOn: $confirmPinSwitch)
                    .toggleStyle(CustomToggleStyle())
                    .labelsHidden()
            }
            .foregroundStyle(Color.appBlue)
            .padding(.top, 20)
            
            OTPInputView(otpDigits: $confirmPIN, isSecure: true)
                .padding(.top, -10)
        }
    }
}

#Preview {
    ChangeTransactionPinView(viewModel: .init())
}
