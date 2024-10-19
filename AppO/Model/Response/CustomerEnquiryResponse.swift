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
    // Custom init for manual creation
    init(availBal: String?, ledgerBal: String?, walletNum: String?, walletStatus: String?) {
        self.availBal = availBal
        self.ledgerBal = ledgerBal
        self.walletNum = walletNum
        self.walletStatus = walletStatus
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


extension CustomerEnquiryResponseData {
    static var mock: CustomerEnquiryResponseData {
        .init(
            addr1: "addresss 12 adreesss banana",
            addr2: "addresss 12 adreesss banana",
            cardList: [Card.mock],
            custID: "000000000000139",
            custName: "new user new user",
            custStatus: "1",
            dob: "08101972",
            instID: "AP",
            maritalStatus: "M",
            nationalID: "1232112321",
            primaryMailAddr: "aaa@g.com",
            primaryMobileNum: "222333444",
            secondaryMailAddr: "aaa@g.com",
            secondaryMobileNum: "222333444"
        )
    }
}

extension Card {
    static var mock: Card {
        .init(
            bin: "636782",
            binName: "APPOPAY PROPRIETORY BIN",
            cardEncodingType: "INSTANT",
            cardEntityType: "@CUSTOMER",
            cardIssuanceType: "VIRTUAL",
            cardName: "new user new user",
            cardRefNum: "636782000000000000000170",
            cardStatus: "007",
            cardStatusDesc: "Active",
            cardType: "PREPAID",
            encodingName: "new user new user",
            expDate: "10102027",
            hashCardNum: "be7187f33b7e42482c712aa5c1e286e2ba15b4f56e3420025f6e7785da4a72d317fad8a521feb9968ab291538d0432721046cb96f05c5940360e757e7bb8262a",
            maskCardNum: "1234 567* **** 0987",
            productID: "03",
            productName: "APPOPAY PROPRIETORY PRODUCT",
            serviceCode: "220",
            subproductID: "002",
            subproductName: "APPOPAY WALLET",
            cardImage: "appo-pay-card",
            walletInfo: WalletInfo.mock
        )
    }
}

extension WalletInfo {
    static var mock: WalletInfo {
        .init(
            availBal: "25.00",
            ledgerBal: "25.00",
            walletNum: "000000000000000000000219",
            walletStatus: "1"
        )
    }
}
