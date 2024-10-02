//
//  CardToCardRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 02/10/2024.
//

import Foundation

struct CardToCardRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let deviceInfo: DeviceInfo
    let requestKey: RequestKey
    let requestData: CardToCardRequestData
    
    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case deviceInfo = "device_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

struct CardToCardRequestData: Codable {
    let isoReqData: ISOCardToCardRequestData
    
    enum CodingKeys: String, CodingKey {
        case isoReqData = "iso_req_data"
    }
}

// MARK: - IsoReqData
struct ISOCardToCardRequestData: Codable {
    let fld11: String
    let fld12: String
    let fld13: String
    let fld14: String
    let fld18: String
    let fld19: String
    let fld2: String
    let fld22: String
    let fld3: String
    let fld37: String
    let fld4: String
    let fld41: String
    let fld42: String
    let fld43: String
    let fld44: String
    let fld49: String
    let fld51: String
    let fld52: String
    let fld56: String
    let mti: String
}

