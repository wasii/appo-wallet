//
//  RegistrationModel.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation

// MARK: - Main Request Structure
struct RegisterRequest: Codable {
    let reqHeaderInfo: RequestHeaderInfo
    let digestInfo: String = "NA"
    let deviceInfo: DeviceInfo
    let requestKey: RequestKey
    let requestData: RegisterRequestData

    enum CodingKeys: String, CodingKey {
        case reqHeaderInfo = "req_header_info"
        case digestInfo = "digest_info"
        case deviceInfo = "device_info"
        case requestKey = "request_key"
        case requestData = "request_data"
    }
}

// MARK: - RequestData
struct RegisterRequestData: Codable {
    let instID: String
    let custName: String
    let mobile: String
    let nameOnCard: String
    let email: String
    let address: String
    let dob: String
    let nationalID: String
    let maritalStatus: String
    let bin: String
    let subproductID: String
    let deviceNo: String

    enum CodingKeys: String, CodingKey {
        case instID = "inst_id"
        case custName = "cust_name"
        case mobile
        case nameOnCard = "name_on_card"
        case email
        case address
        case dob
        case nationalID = "national_id"
        case maritalStatus = "marital_status"
        case bin
        case subproductID = "subproduct_id"
        case deviceNo = "device_no"
    }
}
