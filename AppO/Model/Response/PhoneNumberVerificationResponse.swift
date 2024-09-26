//
//  PhoneNumberVerificationResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 26/09/2024.
//

struct PhoneNumberVerificationResponse: Codable {
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case status
    }
}
