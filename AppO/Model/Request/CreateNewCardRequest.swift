//
//  CreateNewCardRequest.swift
//  AppO
//
//  Created by Abul Jaleel on 03/10/2024.
//

struct CreateNewCardRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let deviceInfo: DeviceInfo
    let requestKey: RequestKey
    let requestData: CreateNewCardRequestData

    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case deviceInfo = "device_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}


struct CreateNewCardRequestData: Codable {
    let instID: String
    let custID: String
    let productID: String
    let subproductID: String

    enum CodingKeys: String, CodingKey {
        case instID = "inst_id"
        case custID = "cust_id"
        case productID = "product_id"
        case subproductID = "subproduct_id"
    }
}
