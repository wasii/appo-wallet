//
//  CustomerValidationResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 30/09/2024.
//

import Foundation

struct CustomerValidationResponse: Codable {
    let riskScore: String
    let signupAllowed: Bool
    
    enum CodingKeys: String, CodingKey {
        case riskScore
        case signupAllowed
    }
}
