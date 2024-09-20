//
//  ShowCardNumberRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 21/09/2024.
//

import Foundation
struct ShowCardNumberRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let requestKey: RequestKey
    let requestData: ShowCardNumberRequestData
    
    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

// MARK: - RequestData
struct ShowCardNumberRequestData: Codable {
    let instID: String
    let cardRefNum: String
    let custId: String
    let mobileNum: String

    enum CodingKeys: String, CodingKey {
        case instID = "inst_id"
        case cardRefNum = "card_ref_num"
        case custId = "cust_id"
        case mobileNum = "mobile_num"
    }
}
