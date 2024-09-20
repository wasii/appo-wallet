//
//  RegistrationResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 23/08/2024.
//

import Foundation

struct RegistrationResponseData: Codable {
    let availBal: String?
    let cardRefNum: String?
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
