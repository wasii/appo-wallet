//
//  AddOnCardView.swift
//  AppO
//
//  Created by Abul Jaleel on 27/08/2024.
//

import SwiftUI

struct AddOnCardView: View {
    @State private var phoneNumber: String = ""
    @State private var nameOnCard: String = ""
    @State private var emailId: String = ""
    @State private var address: String = ""
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            NavigationBarView(title: "Transaction Settings")
            ScrollView {
                CardButtonView(cardType: "Visa Gold Card", cardNumber: "423671******0129" ,cardExpiry: "01/30")
            
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mobile Number")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    HStack {
                        HStack {
                            Text("Panama")
                                .font(.subheadline)
                                .padding(.leading, 5)
                            Text("+507")
                                .font(.subheadline)
                                .foregroundColor(Color.black)
                            Spacer()
                        }
                        .frame(width: 120, height: 57)
                        .background(Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        
                        TextField("Enter phone number", text: $phoneNumber)
                            .customTextfieldStyle()
                    }
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name on Card")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    TextField("Enter name on card", text: $nameOnCard)
                        .customTextfieldStyle()
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email ID")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    TextField("Enter your Email ID", text: $emailId)
                        .customTextfieldStyle()
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Address")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    TextField("Enter your address", text: $address)
                        .customTextfieldStyle()
                }
                .padding(.bottom, 20)
                
                Button {} label: {
                    Text("Submit")
                        .customButtonStyle()
                }
                .padding(.top, 30)
            }
            
            BottomNavigation()
        }
        .padding()
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    AddOnCardView()
}
