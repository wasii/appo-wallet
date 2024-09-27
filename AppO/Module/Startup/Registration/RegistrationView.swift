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
    
    @State private var idType: String = ""
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    @State private var nameOnCard: String = ""
    @State private var idNumber: String = ""
    @State private var gender: String = ""
    @State private var dateOfBirth: String = ""
    @State private var dob: Date = Date()
    @State private var maritalStatus: String = ""
    @State private var maritalStatusPass: String = ""
    
    @State private var email: String = ""
    @State private var address: String = ""
    
    @State private var isSelectIDPickerVisible: Bool = false
    @State private var isDatePickerVisible: Bool = false
    @State private var isGenderPickerVisible: Bool = false
    @State private var isMaritalStatusPickerVisible: Bool = false
    
    private func showSelectIDType() {
        isSelectIDPickerVisible.toggle()
    }
    
    private func showDatePicker() {
        isDatePickerVisible.toggle()
    }
    
    private func showGenderPicker() {
        isGenderPickerVisible.toggle()
    }
    
    private func showMaritalStatusPicker() {
        isMaritalStatusPickerVisible.toggle()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                LoaderView(showLoader: $viewModel.showLoader)
                    .frame(height: UIScreen.main.bounds.height)
            }
            .zIndex(2)
            NavigationBarView(title: "Register Now")
                .zIndex(1)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    idTypeView
                    selectIDTypeView
                        .onTapGesture {
                            hideKeyboard()
                            showSelectIDType()
                        }
                    mobileNumberView
                    firstNameView
                    middleNameView
                    lastNameView
                    walletTypeView
                    nameOnTheCardView
                    idNumberView
                    dobView
                        .onTapGesture {
                            hideKeyboard()
                            showDatePicker()
                        }
                    genderView
                        .onTapGesture {
                            hideKeyboard()
                            showGenderPicker()
                        }
                    maritalStatusView
                        .onTapGesture {
                            hideKeyboard()
                            showMaritalStatusPicker()
                        }
                    emailIDView
                    addressView
                    
                    Button {
                        viewModel.getDMK { success in
                            if success {
                                viewModel.getUserRegistered(custName: "\(firstName) \(lastName)", mobile: viewModel.phoneNumber, nameOnCard: nameOnCard, email: email, address: address, dob: dateOfBirth, nationalId: idNumber, maritalStatus: maritalStatusPass)
                            }
                        }
                    } label: {
                        Text("Next")
                            .customButtonStyle()
                            .disabled(idType.isEmpty || firstName.isEmpty || nameOnCard.isEmpty || gender.isEmpty || dateOfBirth.isEmpty || maritalStatus.isEmpty || email.isEmpty || address.isEmpty)
                            .opacity((idType.isEmpty || firstName.isEmpty || nameOnCard.isEmpty || gender.isEmpty || dateOfBirth.isEmpty || maritalStatus.isEmpty || email.isEmpty || address.isEmpty) ? 0.7 : 1.0)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top, 100)
                .padding(.bottom, 50)
            }
            
            if isSelectIDPickerVisible {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        SelectIDTypeView(isSelectIDTypeVisible: $isSelectIDPickerVisible, selectedIDType: $idType)
                            .padding()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .frame(width: geometry.size.width, height: 270)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        Spacer()
                    }
                    .background(Color.black.opacity(0.7).edgesIgnoringSafeArea(.all))
                }
                .zIndex(1.0)
            }
            
            if isDatePickerVisible {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        DatePickerView(dateOfBirth: $dob, isDatePickerVisible: $isDatePickerVisible, selectedDateText: $dateOfBirth)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .frame(width: geometry.size.width, height: 300)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        Spacer()
                    }
                    .background(Color.black.opacity(0.3).edgesIgnoringSafeArea(.all))
                }
                .zIndex(1.0)
            }
            if isGenderPickerVisible {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        GenderPickerView(isGenderPickerVisible: $isGenderPickerVisible, selectedGender: $gender)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                            .frame(width: geometry.size.width, height: 270)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        Spacer()
                    }
                    .background(Color.black.opacity(0.55).edgesIgnoringSafeArea(.all))
                }
                .zIndex(1.0)
            }
            if isMaritalStatusPickerVisible {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        MaritalStatusPickerView(isMaritalStatusPickerVisible: $isMaritalStatusPickerVisible, selectStatus: $maritalStatus, passStatus: $maritalStatusPass)
                        
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                            .frame(width: geometry.size.width, height: 370)
                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        Spacer()
                    }
                    .background(Color.black.opacity(0.55).edgesIgnoringSafeArea(.all))
                }
                .zIndex(1.0)
            }
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    BottomNavigation()
                        .frame(width: geometry.size.width, height: 50)
                        .background(Color.white)
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar(.hidden, for: .navigationBar)
        .onTapGesture {
            hideKeyboard()
        }
        .onReceive(viewModel.coordinatorState) { state in
            switch (state.state, state.transferable) {
            case(.registered, _):
                AppEnvironment.shared.isLoggedIn = true
            }
        }
        .showError("Error", viewModel.apiError, isPresenting: $viewModel.isPresentAlert)
    }
}

#Preview {
    RegistrationView(viewModel: .init(countryFlag: "🇮🇳", countryCode: "+91", phoneNumber: "1234123412"))
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
                in: ...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .onChange(of: dateOfBirth) { newDate in
                selectedDateText = formattedDate(newDate)
            }
            
            Button(action: {
                isDatePickerVisible = false
            }) {
                Text("Done")
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundColor(.appBlue)
            }
            .padding(.top)
        }
        .padding()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.string(from: date)
    }
}


extension RegistrationView {
    var idTypeView: some View {
        ZStack {
            VStack {
                Text("ID Type")
                    .foregroundStyle(Color.appBlue)
                    .font(AppFonts.bodyEighteenBold)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .cornerRadius(10, corners: .allCorners)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.appBlueForeground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
    
    var selectIDTypeView: some View {
        ZStack {
            VStack {
                if idType.isEmpty {
                    Text("Please Select ID Type")
                        .foregroundStyle(Color.appBlue)
                        .font(AppFonts.bodyEighteenBold)
                } else {
                    Text(idType)
                        .foregroundStyle(Color.appBlue)
                        .font(AppFonts.bodyEighteenBold)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .cornerRadius(10, corners: .allCorners)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.appBlueForeground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
    
    var mobileNumberView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Mobile Number")
                .font(AppFonts.regularTwentyTwo)
            HStack {
                Text(viewModel.countryFlag)
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.black)
                Text(viewModel.countryCode)
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.black)
                
                Image(systemName: "chevron.down")
                    .padding(.trailing, 5)
                    .foregroundStyle(Color.black)
                    .font(AppFonts.bodyEighteenBold)
                
                Text(viewModel.phoneNumber)
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.appBlue)
                    .offset(x: 20)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(10, corners: .allCorners)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.appBlueForeground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBlue, lineWidth: 1)
            )
        }
    }
    
    var firstNameView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("First Name")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $firstName)
                .placeholder(when: firstName.isEmpty) {
                    Text("Enter First Name")
                        .font(AppFonts.bodyEighteenBold)
                        .foregroundColor(.appBlue)
                }
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
    }
    
    var middleNameView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Middle Name")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $middleName)
                .placeholder(when: middleName.isEmpty) {
                    Text("Enter Middle Name (optional)")
                        .font(AppFonts.bodyEighteenBold)
                        .foregroundColor(.appBlue)
                }
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
    }
    
    var lastNameView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Last Name")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $lastName)
                .placeholder(when: lastName.isEmpty) {
                    Text("Enter Last Name")
                        .font(AppFonts.bodyEighteenBold)
                        .foregroundColor(.appBlue)
                }
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
    }
    
    var walletTypeView: some View {
        VStack() {
            HStack {
                Text("Please Select Wallet Type")
                    .font(AppFonts.bodyEighteenBold)
                    .foregroundStyle(Color.appBlue)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.black)
                    .font(AppFonts.bodyEighteenBold)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .cornerRadius(10, corners: .allCorners)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.appBlueForeground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBlue, lineWidth: 1)
            )
        }
    }
    
    var nameOnTheCardView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Name on the Card")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $nameOnCard)
                .placeholder(when: nameOnCard.isEmpty) {
                    Text("Enter Last Name")
                        .font(AppFonts.bodyEighteenBold)
                        .foregroundColor(.appBlue)
                }
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
    }
    
    var idNumberView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("ID Number")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $idNumber)
                .placeholder(when: idNumber.isEmpty) {
                    Text("ID Number")
                        .font(AppFonts.bodyEighteenBold)
                        .foregroundColor(.appBlue)
                }
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
    }
    
    var genderView: some View {
        HStack {
            Text("Gender")
                .font(AppFonts.regularTwentyTwo)
            Spacer()
            
            HStack {
                if gender.isEmpty {
                    Text("Select Gender")
                        .foregroundStyle(Color.appBlue)
                        .font(AppFonts.regularFourteen)
                } else {
                    Text(gender)
                        .foregroundStyle(Color.appBlue)
                        .font(AppFonts.regularFourteen)
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .padding(.trailing, 5)
                    .foregroundStyle(Color.black)
                    .font(AppFonts.bodySixteenBold)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 7)
            .frame(width: 200)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.appBlueForeground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBlue, lineWidth: 1)
            )
        }
    }
    var maritalStatusView: some View {
        HStack {
            Text("Marital Status")
                .font(AppFonts.regularTwentyTwo)
            Spacer()
            
            HStack {
                if maritalStatus.isEmpty {
                    Text("Select Marital Status")
                        .foregroundStyle(Color.appBlue)
                        .font(AppFonts.regularFourteen)
                } else {
                    Text(maritalStatus)
                        .foregroundStyle(Color.appBlue)
                        .font(AppFonts.regularFourteen)
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .padding(.trailing, 5)
                    .foregroundStyle(Color.black)
                    .font(AppFonts.bodySixteenBold)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 7)
            .frame(width: 200)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.appBlueForeground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBlue, lineWidth: 1)
            )
        }
    }
    
    var dobView: some View {
        HStack {
            Text("Date of Birth")
                .font(AppFonts.regularTwentyTwo)
            Spacer()
            
            HStack {
                if dateOfBirth.isEmpty {
                    Text("Select DOB")
                        .foregroundStyle(Color.appBlue)
                        .font(AppFonts.regularFourteen)
                } else {
                    Text(dateOfBirth)
                        .foregroundStyle(Color.appBlue)
                        .font(AppFonts.regularFourteen)
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .padding(.trailing, 5)
                    .foregroundStyle(Color.black)
                    .font(AppFonts.bodySixteenBold)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 7)
            .frame(width: 200)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.appBlueForeground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appBlue, lineWidth: 1)
            )
        }
    }
    
    var emailIDView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Email ID")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $email)
                .placeholder(when: email.isEmpty) {
                    Text("Enter Email ID")
                        .font(AppFonts.bodyEighteenBold)
                        .foregroundColor(.appBlue)
                }
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .keyboardType(.emailAddress)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
    }
    
    var addressView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Address")
                .font(AppFonts.regularTwentyTwo)
            
            TextField("", text: $address)
                .padding()
                .font(AppFonts.bodyEighteenBold)
                .foregroundColor(.black)
                .keyboardType(.default)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.appBlueForeground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.appBlue, lineWidth: 1)
                )
        }
    }
}


struct GenderPickerView: View {
    @State private var gender: String = ""
    @Binding var isGenderPickerVisible: Bool
    @Binding var selectedGender: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("Gender")
                .font(AppFonts.bodyTwentyTwoBold)
            
            RadioButtonField(id: "male", label: "Male", isSelected: gender == "Male") {
                gender = "Male"
            }
            
            RadioButtonField(id: "Female", label: "Female", isSelected: gender == "Female") {
                gender = "Female"
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: 20) {
                    Button{
                        selectedGender = gender
                        isGenderPickerVisible = false
                    } label: {
                        Text("Confirm")
                            .font(AppFonts.bodySixteenBold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appBlue)
                            )
                    }
                    
                    Button{
                        isGenderPickerVisible = false
                    } label: {
                        Text("Close")
                            .font(AppFonts.bodySixteenBold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appBlue)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.appBlueForeground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
}

struct MaritalStatusPickerView: View {
    @State private var status: String = ""
    @Binding var isMaritalStatusPickerVisible: Bool
    @Binding var selectStatus: String
    @Binding var passStatus: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("Marital Status")
                .font(AppFonts.bodyTwentyTwoBold)
            
            RadioButtonField(id: "married", label: "Married", isSelected: status == "Married") {
                status = "Married"
                passStatus = "M"
            }
            
            RadioButtonField(id: "unmarried", label: "Unmarried", isSelected: status == "Unmarried") {
                status = "Unmarried"
                passStatus = "S"
            }
            
            RadioButtonField(id: "divorced", label: "Divorced", isSelected: status == "Divorced") {
                status = "Divorced"
                passStatus = "D"
            }
            
            RadioButtonField(id: "widow", label: "Widow", isSelected: status == "Widow") {
                status = "Widow"
                passStatus = "W"
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: 20) {
                    Button{
                        selectStatus = status
                        isMaritalStatusPickerVisible = false
                    } label: {
                        Text("Confirm")
                            .font(AppFonts.bodySixteenBold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appBlue)
                            )
                    }
                    
                    Button{
                        isMaritalStatusPickerVisible = false
                    } label: {
                        Text("Close")
                            .font(AppFonts.bodySixteenBold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appBlue)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.appBlueForeground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
}

struct SelectIDTypeView: View {
    @State private var idType: String = ""
    @Binding var isSelectIDTypeVisible: Bool
    @Binding var selectedIDType: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("Please Select ID Type")
                .font(AppFonts.bodyTwentyTwoBold)
            
            RadioButtonField(id: "nationalId", label: "National ID", isSelected: idType == "National ID") {
                idType = "National ID"
            }
            
            RadioButtonField(id: "passport", label: "Passport", isSelected: idType == "Passport") {
                idType = "Passport"
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: 20) {
                    Button{
                        selectedIDType = idType
                        isSelectIDTypeVisible = false
                    } label: {
                        Text("Confirm")
                            .font(AppFonts.bodySixteenBold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appBlue)
                            )
                    }
                    
                    Button{
                        isSelectIDTypeVisible = false
                    } label: {
                        Text("Close")
                            .font(AppFonts.bodySixteenBold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.appBlue)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.appBlueForeground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
}
