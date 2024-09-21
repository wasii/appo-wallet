//
//  ShowCardNumberResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 21/09/2024.
//


import Foundation

struct ShowCardNumberResponse: Codable {
    let dCardNum: String?
    
    enum CodingKeys: String, CodingKey {
        case dCardNum = "d_card_num"
    }
}
