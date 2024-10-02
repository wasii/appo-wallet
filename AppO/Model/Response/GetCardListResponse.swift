//
//  GetCardListResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 02/10/2024.
//

import Foundation


// MARK: - GetCardListResponse
struct GetCardListResponse: Codable {
    let authAction: String?
    let authBy: String?
    let authDate: String?
    let authStatus: String?
    let authTime: String?
    let bin: String?
    let binName: String?
    let cardEncodingType: String?
    let cardEntityType: String?
    let cardGenMtd: String?
    let cardIssuanceType: String?
    let cardType: String?
    let createdBy: String?
    let createdDate: String?
    let createdTime: String?
    let deauthBy: String?
    let deauthDate: String?
    let deauthReason: String?
    let deauthTime: String?
    let deletedBy: String?
    let deletedDate: String?
    let deletedTime: String?
    let instId: String?
    let maxWallet: Int?
    let multiCurrencyWalletFlag: String?
    let productId: String?
    let productWiseBalReq: String?
    let reloadableFlag: String?
    let rowIntegrityChecksum: String?
    let subproductId: String?
    let subproductName: String?
    let subproductStatus: String?
    let updatedBy: String?
    let updatedDate: String?
    let updatedTime: String?

    enum CodingKeys: String, CodingKey {
        case authAction = "auth_action"
        case authBy = "auth_by"
        case authDate = "auth_date"
        case authStatus = "auth_status"
        case authTime = "auth_time"
        case bin
        case binName = "bin_name"
        case cardEncodingType = "card_encoding_type"
        case cardEntityType = "card_entity_type"
        case cardGenMtd = "card_gen_mtd"
        case cardIssuanceType = "card_issuance_type"
        case cardType = "card_type"
        case createdBy = "created_by"
        case createdDate = "created_date"
        case createdTime = "created_time"
        case deauthBy = "deauth_by"
        case deauthDate = "deauth_date"
        case deauthReason = "deauth_reason"
        case deauthTime = "deauth_time"
        case deletedBy = "deleted_by"
        case deletedDate = "deleted_date"
        case deletedTime = "deleted_time"
        case instId = "inst_id"
        case maxWallet = "max_wallet"
        case multiCurrencyWalletFlag = "multi_currency_wallet_flag"
        case productId = "product_id"
        case productWiseBalReq = "product_wise_bal_req"
        case reloadableFlag = "reloadable_flag"
        case rowIntegrityChecksum = "row_integrity_checksum"
        case subproductId = "subproduct_id"
        case subproductName = "subproduct_name"
        case subproductStatus = "subproduct_status"
        case updatedBy = "updated_by"
        case updatedDate = "updated_date"
        case updatedTime = "updated_time"
    }
}
