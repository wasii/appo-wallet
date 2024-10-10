//
//  GetMiniStatementResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 30/09/2024.
//

import Foundation

struct GetMiniStatementResponse: Codable {
    let acqInfo: MiniStatmentAcqInfo
    let issInfo: MiniStatmentIssInfo
    let fwdInfo: MiniStatmentFwdInfo
    let txfInfo: MiniStatmentTxfInfo
    let settInfo: MiniStatmentSettInfo
    let cardInfo: MiniStatmentCardInfo
    let custInfo: MiniStatmentCustInfo
    let corporateInfo: MiniStatmentCorporateInfo
    let clientInfo: MiniStatmentClientInfo
    let driverInfo: MiniStatmentDriverInfo
    let acctInfo: MiniStatmentAcctInfo
    let walletInfo: MiniStatmentWalletInfo
    let termInfo: MiniStatmentTermInfo
    let channelInfo: MiniStatmentChannelInfo
    let acceptorInfo: MiniStatmentAcceptorInfo
    let storeInfo: MiniStatmentStoreInfo
    var additionalInfo: MiniStatmentAdditionalInfo
    let txnInfo: MiniStatmentTxnInfo
    let securityInfo: MiniStatmentSecurityInfo
    let respInfo: MiniStatmentRespInfoInner
    
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
// MARK: - MiniStatmentAcqInfo
struct MiniStatmentAcqInfo: Codable {
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

// MARK: - MiniStatmentIssInfo
struct MiniStatmentIssInfo: Codable {
    let issType: String?
    let issInst: String?
    let issBin: String?
    let issCntryCode: String?
    let issCurrCode: String?
    let issuer: String?
    let issCardProduct: String?
    let issCardSubproduct: String?
    
    enum CodingKeys: String, CodingKey {
        case issType = "iss_type"
        case issInst = "iss_inst"
        case issBin = "iss_bin"
        case issCntryCode = "iss_cntry_code"
        case issCurrCode = "iss_curr_code"
        case issuer
        case issCardProduct = "iss_card_product"
        case issCardSubproduct = "iss_card_subproduct"
    }
}

// MARK: - MiniStatmentFwdInfo
struct MiniStatmentFwdInfo: Codable {}

// MARK: - MiniStatmentTxfInfo
struct MiniStatmentTxfInfo: Codable {}

// MARK: - MiniStatmentSettInfo
struct MiniStatmentSettInfo: Codable {}

// MARK: - MiniStatmentCardInfo
struct MiniStatmentCardInfo: Codable {
    let cardNum: String?
    let cardRefNum: String?
    let mCardNum: String?
    let eCardNum: String?
    let cardSeqNum: String?
    
    enum CodingKeys: String, CodingKey {
        case cardNum = "card_num"
        case cardRefNum = "card_ref_num"
        case mCardNum = "m_card_num"
        case eCardNum = "e_card_num"
        case cardSeqNum = "card_seq_num"
    }
}

// MARK: - MiniStatmentCustInfo
struct MiniStatmentCustInfo: Codable {
    let custMobileNum: String?
    
    enum CodingKeys: String, CodingKey {
        case custMobileNum = "cust_mobile_num"
    }
}

// MARK: - MiniStatmentCorporateInfo
struct MiniStatmentCorporateInfo: Codable {}

// MARK: - MiniStatmentClientInfo
struct MiniStatmentClientInfo: Codable {}

// MARK: - MiniStatmentDriverInfo
struct MiniStatmentDriverInfo: Codable {}

// MARK: - MiniStatmentAcctInfo
struct MiniStatmentAcctInfo: Codable {
    let availBal: String?
    let ledgerBal: String?
    
    enum CodingKeys: String, CodingKey {
        case availBal = "avail_bal"
        case ledgerBal = "ledger_bal"
    }
}

// MARK: - MiniStatmentWalletInfo
struct MiniStatmentWalletInfo: Codable {}

// MARK: - MiniStatmentTermInfo
struct MiniStatmentTermInfo: Codable {
    let termId: String?
    let termLoc: String?
    
    enum CodingKeys: String, CodingKey {
        case termId = "term_id"
        case termLoc = "term_loc"
    }
}

// MARK: - MiniStatmentChannelInfo
struct MiniStatmentChannelInfo: Codable {
    let channelName: String?
    
    enum CodingKeys: String, CodingKey {
        case channelName = "channel_name"
    }
}

// MARK: - MiniStatmentAcceptorInfo
struct MiniStatmentAcceptorInfo: Codable {
    let acceptorId: String?
    let mcc: String?
    
    enum CodingKeys: String, CodingKey {
        case acceptorId = "acceptor_id"
        case mcc
    }
}

// MARK: - MiniStatmentStoreInfo
struct MiniStatmentStoreInfo: Codable {}

// MARK: - MiniStatmentAdditionalInfo
struct MiniStatmentAdditionalInfo: Codable {
    let addInfo1: String?
    var transaction: [Transaction]?
    
    enum CodingKeys: String, CodingKey {
        case addInfo1 = "add_info_1"
        case transaction
    }
}

// MARK: - MiniStatmentTxnInfo
struct MiniStatmentTxnInfo: Codable {
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

// MARK: - MiniStatmentSecurityInfo
struct MiniStatmentSecurityInfo: Codable {
    let pinBlock: String?
    let commKeyULmk: String?
    
    enum CodingKeys: String, CodingKey {
        case pinBlock = "pin_block"
        case commKeyULmk = "comm_key_u_lmk"
    }
}

// MARK: - MiniStatmentRespInfoInner
struct MiniStatmentRespInfoInner: Codable {
    let rejectCode: String?
    let rejectLongDesc: String?
    let rejectShortDesc: String?
    let respCode: String?
    let respDesc: String?
    let respStatus: Int?
    let txnFlag: Bool?
    
    enum CodingKeys: String, CodingKey {
        case rejectCode = "reject_code"
        case rejectLongDesc = "reject_long_desc"
        case rejectShortDesc = "reject_short_desc"
        case respCode = "resp_code"
        case respDesc = "resp_desc"
        case respStatus = "resp_status"
        case txnFlag = "txn_flag"
    }
}

struct Transaction: Codable, Hashable {
    let date: String?
    let time: String?
    let detail: String?
    let amount: String?
}
