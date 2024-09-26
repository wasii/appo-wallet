//
//  CustomerBalanceEnquiryResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 26/09/2024.
//

struct CustomerBalanceEnquiryResponse: Codable {
    let availBal: String
    
    enum CodingKeys: String, CodingKey {
        case availBal = "avail_bal"
    }
}
