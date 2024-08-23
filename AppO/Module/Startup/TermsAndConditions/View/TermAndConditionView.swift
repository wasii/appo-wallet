//
//  TermAndConditionView.swift
//  AppO
//
//  Created by Abul Jaleel on 15/08/2024.
//

import SwiftUI

struct TermAndConditionView: View {
    
//    @Environment(\.dismiss) var dismiss
    @State private var isChecked: Bool = false
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
//        NavigationStack {
            
            VStack(alignment: .leading, spacing: 20) {
                NavigationBarView(title: "Terms and Conditions")
                
                ScrollView {
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                }
                HStack {
                    Button(action: {
                        isChecked.toggle()
                    }) {
                        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                            .foregroundColor(isChecked ? .appBlue : .gray)
                            .font(.system(size: 25))
                    }
                    
                    // Terms and Conditions text
                    Text("I have read the terms and conditions")
                        .font(.body)
                        .foregroundColor(.primary)
                    Spacer()
                }
//                NavigationLink(destination: EnterMPINView(text: .constant(""))) {
//                    
//                }
                Text("NEXT")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(isChecked ? Color.appBlue : Color.appBlue.opacity(0.4))
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                    .disabled(!isChecked)
                    .onTapGesture {
                        navigator.navigate(to: .enterMPINView(viewModel: .init()))
                    }
                
                
            }
            .padding()
            .toolbar(.hidden, for: .navigationBar)
            .background(.appBackground)
        }
//    }
}

#Preview {
    TermAndConditionView()
}
