//
//  RegistrationResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation

// MARK: - Main Response Structure
struct RegistrationResponse: Codable {
    let respInfo: RespInfo

    enum CodingKeys: String, CodingKey {
        case respInfo = "resp_info"
    }
}

// MARK: - RespInfo
struct RespInfo: Codable {
    let appCorrectiveAction: String
    let appErrDesc: String
    let rejectCode: String
    let rejectLongDesc: String
    let rejectModule: String
    let rejectModuleType: String
    let rejectShortDesc: String
    let respCode: String
    let respData: RespData
    let respDesc: String
    let respStatus: Int

    enum CodingKeys: String, CodingKey {
        case appCorrectiveAction = "app_corrective_action"
        case appErrDesc = "app_err_desc"
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

// MARK: - RespData
struct RespData: Codable {
    let availBal: String
    let cardRefNum: String
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
        case cardRefNum = "card_ref_num"
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


extension RegistrationResponse: Mockable {
    static var mock: RegistrationResponse {
        return RegistrationResponse(
            respInfo: .init(
                appCorrectiveAction: "NA",
                appErrDesc: "NA",
                rejectCode: "0",
                rejectLongDesc: "RCapproved",
                rejectModule: "",
                rejectModuleType: "INTERNAL",
                rejectShortDesc: "RCapproved",
                respCode: "0",
                respData: .init(
                    availBal: "0",
                    cardRefNum: "636782000000000000000101",
                    custID: "000000000000081",
                    custName: "John Doe",
                    cvv1: "873",
                    cvv2: "873",
                    eCardNum: "032B027FB66B26F3D2FB027FB66B26F3D2FBxwXJ7LoEB25Mro6Ytkn4o1+82DommpiCrdDW6d/Bcw",
                    expDate: "20092027",
                    icvv: "706",
                    instID: "AP",
                    maskCardNum: "636782******0431",
                    productName: "APPOPAY WALLET"
                ),
                respDesc: "RCapproved",
                respStatus: 200
            )
        )
    }
}
