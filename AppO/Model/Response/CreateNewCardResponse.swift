//
//  CreateNewCardResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 03/10/2024.
//

import Foundation

struct CreateNewCardResponse: Codable {
    let cardRefNum: String?
    let cardStatus: String?
    let cardStatusDesc: String?
    let custID: String?
    let custName: String?
    let cvv1: String?
    let cvv2: String?
    let eCardNum: String?
    let expDate: String?
    let icvv: String?
    let instID: String?
    let maskCardNum: String?
    let productName: String?
    
    enum CodingKeys: String, CodingKey {
        case cardRefNum = "card_ref_num"
        case cardStatus = "card_status"
        case cardStatusDesc = "card_status_desc"
        case custID = "cust_id"
        case custName = "cust_name"
        case cvv1 = "cvv1"
        case cvv2 = "cvv2"
        case eCardNum = "e_card_num"
        case expDate = "exp_date"
        case icvv = "icvv"
        case instID = "inst_id"
        case maskCardNum = "mask_card_num"
        case productName = "product_name"
    }
}
