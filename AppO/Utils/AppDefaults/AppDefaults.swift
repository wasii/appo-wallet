//
//  AppDefaults.swift
//  AppO
//
//  Created by Abul Jaleel on 21/09/2024.
//


import Foundation

class AppDefaults: UserDefaults {

    static var shared = AppDefaults()

    override class var standard: UserDefaults {
        return UserDefaults.standard
    }

    static func clearUserDefaults() {
        AppDefaults.isLogin = false
        AppDefaults.newUser = nil
        AppDefaults.user = nil
    }
    
    static var isLogin: Bool {
        get { AppDefaults[#function] ?? false }
        set { AppDefaults[#function] = newValue }
    }

    static var isLocalAuthenticationEnabled: Bool {
        get { AppDefaults[#function] ?? false }
        set { AppDefaults[#function] = newValue }
    }
    
    static var newUser: RegistrationResponseData? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var user: CustomerEnquiryResponseData? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var selected_card: Card? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var mobile: String? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var deviceId: String? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var mobilePin: String? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var dmk: String? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    static var dmk_kcv: String? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var dek: String? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var dek_kcv: String? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var isTermConditionsChecked: Bool? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var temp_pin: String? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
    
    static var temp_cardnumber: String? {
        get { AppDefaults[#function] }
        set { AppDefaults[#function] = newValue }
    }
}

extension AppDefaults {

    static subscript<T: Codable>(key: String) -> T? {
        get { AppDefaults.shared.getValue(key) }
        set(newValue) { AppDefaults.shared.setValue(newValue, for: key) }
    }

    fileprivate func getValue<T: Codable>(_ key: String) -> T? {
        guard let data = AppDefaults.standard.data(forKey: key) else { return nil }
        return decode(data).0
    }

    fileprivate func setValue<T: Codable>(_ value: T, for key: String) {
        let decoded = encode(value)
        if let data = decoded.data {
            AppDefaults.standard.set(data, forKey: key)
            AppDefaults.standard.synchronize()
        } else {
            print("Value not set for \(key): \(decoded.error?.localizedDescription ?? "")")
        }
    }

}
