//
//  ChangeCardStatusResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 27/09/2024.
//

struct ChangeCardStatusResponse: Codable {
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case status
    }
}
