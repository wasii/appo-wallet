//
//  CustomerEnquiryResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 20/09/2024.
//

import Foundation

struct CustomerEnquiryResponseData: Codable, Hashable {
    let addr1: String?
    let addr2: String?
    var cardList: [Card]?
    let custID: String?
    let custName: String?
    let custStatus: String?
    let dob: String?
    let instID: String?
    let maritalStatus: String?
    let nationalID: String?
    let primaryMailAddr: String?
    let primaryMobileNum: String?
    let secondaryMailAddr: String?
    let secondaryMobileNum: String?
    
    enum CodingKeys: String, CodingKey {
        case addr1 = "addr_1"
        case addr2 = "addr_2"
        case cardList = "card_list"
        case custID = "cust_id"
        case custName = "cust_name"
        case custStatus = "cust_status"
        case dob
        case instID = "inst_id"
        case maritalStatus = "marital_status"
        case nationalID = "national_id"
        case primaryMailAddr = "primary_mail_addr"
        case primaryMobileNum = "primary_mobile_num"
        case secondaryMailAddr = "secondary_mail_addr"
        case secondaryMobileNum = "secondary_mobile_num"
    }
}

struct Card: Codable, Hashable {
    let bin: String?
    let binName: String?
    let cardEncodingType: String?
    let cardEntityType: String?
    let cardIssuanceType: String?
    let cardName: String?
    let cardRefNum: String?
    let cardStatus: String?
    let cardStatusDesc: String?
    let cardType: String?
    let encodingName: String?
    let expDate: String?
    let hashCardNum: String?
    var maskCardNum: String?
    let productID: String?
    let productName: String?
    let serviceCode: String?
    let subproductID: String?
    let subproductName: String?
    var cardImage: String?
    let walletInfo: WalletInfo?
    
    enum CodingKeys: String, CodingKey {
        case bin
        case binName = "bin_name"
        case cardEncodingType = "card_encoding_type"
        case cardEntityType = "card_entity_type"
        case cardIssuanceType = "card_issuance_type"
        case cardName = "card_name"
        case cardRefNum = "card_ref_num"
        case cardStatus = "card_status"
        case cardStatusDesc = "card_status_desc"
        case cardType = "card_type"
        case encodingName = "encoding_name"
        case expDate = "exp_date"
        case hashCardNum = "hash_card_num"
        case maskCardNum = "mask_card_num"
        case productID = "product_id"
        case productName = "product_name"
        case serviceCode = "service_code"
        case subproductID = "subproduct_id"
        case subproductName = "subproduct_name"
        case cardImage = "card_image"
        case walletInfo = "wallet_info"
    }
}

struct WalletInfo: Codable, Hashable {
    let availBal: String?
    let ledgerBal: String?
    let walletNum: String?
    let walletStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case availBal = "avail_bal"
        case ledgerBal = "ledger_bal"
        case walletNum = "wallet_num"
        case walletStatus = "wallet_status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode as normal string
        let rawAvailBal = try container.decodeIfPresent(String.self, forKey: .availBal)
        let rawLedgerBal = try container.decodeIfPresent(String.self, forKey: .ledgerBal)
        
        // Format the availBal to two decimal places if it's a valid number
        if let rawAvailBal = rawAvailBal, let doubleValue = Double(rawAvailBal),
           let rawLedgerBal = rawLedgerBal, let doubleLedgerValue = Double(rawLedgerBal){
            self.availBal = String(format: "%.2f", doubleValue)
            self.ledgerBal = String(format: "%.2f", doubleLedgerValue)
        } else {
            self.availBal = rawAvailBal
            self.ledgerBal = rawLedgerBal
        }
        
        // Decode other properties
        self.walletNum = try container.decodeIfPresent(String.self, forKey: .walletNum)
        self.walletStatus = try container.decodeIfPresent(String.self, forKey: .walletStatus)
    }
}
