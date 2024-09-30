//
//  TransactionPinPopUpView.swift
//  AppO
//
//  Created by Abul Jaleel on 30/09/2024.
//
import SwiftUI

struct TransactionPinPopUpView: View {
    @State private var enteredPIN = ""
    @Binding var isShowTransactionPin: Bool
    private let pinLength = 4
    
    let gridItems = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var closure: ()->()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
            
                VStack(spacing: 20) {
                    HStack {
                        Image("app_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 50)
                        
                        Spacer()
                        Button(action: {
                            isShowTransactionPin = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    
                    // Title
                    Text("Transaction Pin")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Dots for PIN
                    HStack(spacing: 15) {
                        ForEach(0..<pinLength, id: \.self) { index in
                            Circle()
                                .fill(index < enteredPIN.count ? Color.black : Color.gray.opacity(0.3))
                                .frame(width: 35, height: 35)
                        }
                    }
                    .padding(.vertical)
                    
                    // Numpad
                    LazyVGrid(columns: gridItems, spacing: 20) {
                        ForEach(1..<10) { number in
                            Button(action: {
                                appendPin("\(number)")
                            }) {
                                Circle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Text("\(number)")
                                            .font(.largeTitle)
                                            .foregroundColor(.black)
                                    )
                            }
                        }
                        Button(action: {
                            clearPin()
                        }) {
                            Text("CLEAR")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            appendPin("0")
                        }) {
                            Circle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text("0")
                                        .font(.largeTitle)
                                        .foregroundColor(.black)
                                )
                        }
                        
                        Button(action: {
                            if enteredPIN.count == 4 {
                                AppDefaults.temp_pin = enteredPIN
                                isShowTransactionPin = false
                                closure()
                            }
                        }) {
                            Text("CONFIRM")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(Color.appBlueForeground)
            }
        }
        .frame(maxWidth: .infinity, alignment: .bottom) // Align VStack at the bottom
    }
    
    // Helper functions to manage PIN input
    private func appendPin(_ number: String) {
        if enteredPIN.count < pinLength {
            enteredPIN.append(number)
        }
    }
    
    private func clearPin() {
        if !enteredPIN.isEmpty {
            enteredPIN.removeLast()
        }
    }
}

#Preview {
    TransactionPinPopUpView(isShowTransactionPin: .constant(true)) {}
}
