//
//  GetCardListRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 02/10/2024.
//

import Foundation

struct GetCardListRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let requestKey: RequestKey
    let requestData: GetCardListRequestData
    
    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

struct GetCardListRequestData: Codable {
    let instId: String
    
    enum CodingKeys: String, CodingKey {
        case instId = "inst_id"
    }
}
