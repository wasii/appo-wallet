//
//  GetMiniStatementResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 30/09/2024.
//

import Foundation

struct GetMiniStatementResponse: Codable {
    let acqInfo: AcquirerInfo?
    let issInfo: IssuerInfo?
    let fwdInfo: EmptyInfo?
    let txfInfo: EmptyInfo?
    let settInfo: EmptyInfo?
    let cardInfo: CardInfo?
    let custInfo: CustomerInfo?
    let corporateInfo: EmptyInfo?
    let clientInfo: EmptyInfo?
    let driverInfo: EmptyInfo?
    let acctInfo: AccountInfo?
    let walletInfo: EmptyInfo?
    let termInfo: TerminalInfo?
    let channelInfo: ChannelInfo?
    let acceptorInfo: AcceptorInfo?
    let storeInfo: EmptyInfo?
    let additionalInfo: AdditionalInfo?
    let txnInfo: TransactionInfo?
    let securityInfo: SecurityInfo?
    let respInfo: ResponseInfo?
    
}
// MARK: - EmptyInfo
struct EmptyInfo: Codable {}

struct AdditionalInfo: Codable {
    var addInfoOne: String
    var transaction: Transaction
    
    enum CodingKeys: String, CodingKey {
        case addInfoOne = "add_info_1"
        case transaction
    }
}

struct Transaction: Codable {
    let date: String?
    let time: String?
    let detail: String?
    let amount: String?
}
