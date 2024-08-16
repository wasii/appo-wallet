//
//  PhoneNumberModel.swift
//  AppO
//
//  Created by Abul Jaleel on 16/08/2024.
//

import Foundation

struct PhoneNumberModel: Codable, Identifiable {
    let id: String
    let name: String
    let flag: String
    let code: String
    let dial_code: String
    let pattern: String
    let limit: Int
    
    static let allCountry: [PhoneNumberModel] = Bundle.main.decode("CountryNumbers.json")
    static let example = allCountry[0]
}
