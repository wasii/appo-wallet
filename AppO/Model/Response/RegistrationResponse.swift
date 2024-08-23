//
//  RegistrationResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation

// MARK: - Registration Response
struct RegistrationResponse: Codable {
    let respInfo: RegistrationResponseInfo
    
    enum CodingKeys: String, CodingKey {
        case respInfo = "resp_info"
    }
}

// MARK: - Registration Response Info
struct RegistrationResponseInfo: Codable {
    let rejectCode: String
    let rejectLongDesc: String
    let rejectModule: String
    let rejectModuleType: String
    let rejectShortDesc: String
    let respCode: String
    let respData: RegistrationResponseData
    let respDesc: String
    let respStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case rejectCode = "reject_code"
        case rejectLongDesc = "reject_long_desc"
        case rejectModule = "reject_module"
        case rejectModuleType = "reject_module_type"
        case rejectShortDesc = "reject_short_desc"
        case respCode = "resp_code"
        case respData = "resp_data"
        case respDesc = "resp_desc"
        case respStatus = "resp_status"
    }
}

// MARK: - Registration Response Data
struct RegistrationResponseData: Codable {
    let availBal: String
    let custID: String
    let custName: String
    let cvv1: String
    let cvv2: String
    let eCardNum: String
    let expDate: String
    let icvv: String
    let instID: String
    let maskCardNum: String
    let productName: String
    
    enum CodingKeys: String, CodingKey {
        case availBal = "avail_bal"
        case custID = "cust_id"
        case custName = "cust_name"
        case cvv1
        case cvv2
        case eCardNum = "e_card_num"
        case expDate = "exp_date"
        case icvv
        case instID = "inst_id"
        case maskCardNum = "mask_card_num"
        case productName = "product_name"
    }
}
