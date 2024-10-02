//
//  CardToCardResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 02/10/2024.
//
import Foundation

struct CardToCardResponse: Codable {
    let acqInfo: AcquirerInfo?
    let issInfo: IssuerInfo?
    let fwdInfo: ForwardingInfo?
    let txfInfo: TransactionForwardingInfo?
    let settInfo: SettlementInfo?
    let cardInfo: CardInfo?
    let custInfo: CustomerInfo?
    let corporateInfo: CorporateInfo?
    let clientInfo: ClientInfo?
    let driverInfo: DriverInfo?
    let acctInfo: AccountInfo?
    let walletInfo: WalletInfo?
    let termInfo: TerminalInfo?
    let channelInfo: ChannelInfo?
    let acceptorInfo: AcceptorInfo?
    let storeInfo: StoreInfo?
    let additionalInfo: AdditionalInfo?
    let txnInfo: TransactionInfo?
    let securityInfo: SecurityInfo?
    let respInfo: ResponseInfo?

    enum CodingKeys: String, CodingKey {
        case acqInfo = "acq_info"
        case issInfo = "iss_info"
        case fwdInfo = "fwd_info"
        case txfInfo = "txf_info"
        case settInfo = "sett_info"
        case cardInfo = "card_info"
        case custInfo = "cust_info"
        case corporateInfo = "corporate_info"
        case clientInfo = "client_info"
        case driverInfo = "driver_info"
        case acctInfo = "acct_info"
        case walletInfo = "wallet_info"
        case termInfo = "term_info"
        case channelInfo = "channel_info"
        case acceptorInfo = "acceptor_info"
        case storeInfo = "store_info"
        case additionalInfo = "additional_info"
        case txnInfo = "txn_info"
        case securityInfo = "security_info"
        case respInfo = "resp_info"
    }
}

// Acquirer Information
struct AcquirerInfo: Codable {
    let acquirer: String?
    let acqType: String?
    let acqSubType: String?
    let acqInst: String?
    let acqCntryCode: String?
    let acqCurrCode: String?

    enum CodingKeys: String, CodingKey {
        case acquirer
        case acqType = "acq_type"
        case acqSubType = "acq_sub_type"
        case acqInst = "acq_inst"
        case acqCntryCode = "acq_cntry_code"
        case acqCurrCode = "acq_curr_code"
    }
}

// Issuer Information
struct IssuerInfo: Codable {
    let issType: String?
    let issInst: String?
    let issBin: String?
    let issCntryCode: String?
    let issCurrCode: String?
    let issuer: String?

    enum CodingKeys: String, CodingKey {
        case issType = "iss_type"
        case issInst = "iss_inst"
        case issBin = "iss_bin"
        case issCntryCode = "iss_cntry_code"
        case issCurrCode = "iss_curr_code"
        case issuer
    }
}

// Forwarding Information
struct ForwardingInfo: Codable {}

// Transaction Forwarding Information
struct TransactionForwardingInfo: Codable {}

// Settlement Information
struct SettlementInfo: Codable {}

// Customer Information
struct CustomerInfo: Codable {
    let custMobileNum: String?

    enum CodingKeys: String, CodingKey {
        case custMobileNum = "cust_mobile_num"
    }
}

// Corporate Information
struct CorporateInfo: Codable {}

// Client Information
struct ClientInfo: Codable {}

// Driver Information
struct DriverInfo: Codable {}

// Account Information
struct AccountInfo: Codable {}

// Terminal Information
struct TerminalInfo: Codable {
    let termId: String?
    let termLoc: String?

    enum CodingKeys: String, CodingKey {
        case termId = "term_id"
        case termLoc = "term_loc"
    }
}

// Store Information
struct StoreInfo: Codable {}

// Additional Information
struct AdditionalInfo: Codable {}

// Transaction Information
struct TransactionInfo: Codable {
    let reqId: String?
    let recordNum: String?
    let mti: String?
    let reqMti: String?
    let reqPcode: String?
    let pcode: String?
    let txnType: String?
    let txnCategory: String?
    let txnName: String?
    let txnAmount: String?
    let tranDate: String?
    let tranTime: String?
    let stan: String?
    let localDate: String?
    let localTime: String?
    let expiryDate: String?
    let rrn: String?
    let posEntryMode: String?
    let posCondCode: String?

    enum CodingKeys: String, CodingKey {
        case reqId = "req_id"
        case recordNum = "record_num"
        case mti
        case reqMti = "req_mti"
        case reqPcode = "req_pcode"
        case pcode
        case txnType = "txn_type"
        case txnCategory = "txn_category"
        case txnName = "txn_name"
        case txnAmount = "txn_amount"
        case tranDate = "tran_date"
        case tranTime = "tran_time"
        case stan
        case localDate = "local_date"
        case localTime = "local_time"
        case expiryDate = "expiry_date"
        case rrn
        case posEntryMode = "pos_entry_mode"
        case posCondCode = "pos_cond_code"
    }
}

// Response Information
struct ResponseInfo: Codable {
    let respCode: String?
    let respDesc: String?
    let rejectCode: String?

    enum CodingKeys: String, CodingKey {
        case respCode = "resp_code"
        case respDesc = "resp_desc"
        case rejectCode = "reject_code"
    }
}
