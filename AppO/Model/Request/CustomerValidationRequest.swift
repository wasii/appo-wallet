//
//  CustomerValidationRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 30/09/2024.
//

import Foundation

struct CustomerValidationRequest: Codable {
    let name: String
    let countryOfOrigin: String
    let politicallyExposedPerson: Bool
    let id: String
    let identityType: String
    let identityNumber: String
    let phoneNumber: String
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case countryOfOrigin
        case politicallyExposedPerson
        case id
        case identityType
        case identityNumber
        case phoneNumber
    }
}
