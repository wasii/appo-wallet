//
//  RegistrationView.swift
//  AppO
//
//  Created by Abul Jaleel on 19/08/2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    @EnvironmentObject var navigator: Navigator
    
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    @State private var nameOnCard: String = ""
    @State private var gender: String = ""
    @State private var dateOfBirth: String = ""
    @State private var dob: Date = Date()
    @State private var email: String = ""
    @State private var address: String = ""
    
    @State private var isDatePickerVisible: Bool = false
    
    private func showDatePicker() {
        isDatePickerVisible.toggle()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationBarView(title: "")
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mobile Number")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.gray)
                    HStack {
                        HStack {
                            Text(viewModel.countryFlag)
                                .font(.system(size: 35))
                                .padding(.leading, 5)
                            Text(viewModel.countryCode)
                                .font(.subheadline)
                                .foregroundColor(Color.black)
                            Spacer()
                        }
                        .frame(width: 100, height: 57)
                        .background(Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        
                        Text(viewModel.phoneNumber)
                            .customTextfieldStyle()
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("First Name")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.gray)
                    HStack {
                        TextField("Enter first name", text: $firstName)
                            .customTextfieldStyle()
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Middle Name")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.gray)
                    HStack {
                        TextField("Enter middle name (optional)", text: $middleName)
                            .customTextfieldStyle()
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Last Name")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.gray)
                    HStack {
                        TextField("Enter last name", text: $lastName)
                            .customTextfieldStyle()
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name on Card")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.gray)
                    HStack {
                        TextField("Enter name on card", text: $nameOnCard)
                            .customTextfieldStyle()
                    }
                }
                
                HStack {
                    Text("Gender")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.gray)
                        
                    RadioButtonField(id: "male", label: "Male", isSelected: gender == "Male") {
                        gender = "Male"
                    }
                    RadioButtonField(id: "Female", label: "Female", isSelected: gender == "Female") {
                        gender = "Female"
                    }
                    Spacer()
                }
                .padding(.top, 20)
                
                HStack {
                    Text("Date of Birth")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.gray)
                    
                    TextField("Select date of birth", text: $dateOfBirth)
                        .customTextfieldStyle()
                        .disabled(true)
                        .onTapGesture {
                            // Action to open the date picker
                            showDatePicker()
                        }
                    Spacer()
                }
                .padding(.top, 20)
                
                if isDatePickerVisible {
                    DatePickerView(dateOfBirth: $dob, isDatePickerVisible: $isDatePickerVisible, selectedDateText: $dateOfBirth)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email ID")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.gray)
                    HStack {
                        TextField("Enter email address", text: $email)
                            .customTextfieldStyle()
                    }
                }
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Address")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.gray)
                    HStack {
                        CustomTextEditor(text: $address)
                            .frame(height: 107)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                
                NavigationLink(destination: SetupMobilePinView()) {
                    Text("NEXT")
                        .customButtonStyle()
                }
                .padding(.top, 20)
                
                Spacer()
            }
            BottomNavigation()
        }
        .padding()
        .toolbar(.hidden, for: .navigationBar)
        .background(Color.appBackground)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    RegistrationView(viewModel: .init(countryFlag: "🇮🇳", countryCode: "+91", phoneNumber: "1234123412"))
}

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear // Set background to clear
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}



struct DatePickerView: View {
    @Binding var dateOfBirth: Date
    @Binding var isDatePickerVisible: Bool
    @Binding var selectedDateText: String
    
    var body: some View {
        VStack {
            DatePicker(
                "",
                selection: $dateOfBirth,
                displayedComponents: [.date]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .onChange(of: dateOfBirth) {_, newDate in
                selectedDateText = formattedDate(newDate)
            }
            
            Button(action: {
                isDatePickerVisible = false
            }) {
                Text("Done")
                    .foregroundColor(.blue)
            }
            .padding(.top)
        }
        .padding()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
