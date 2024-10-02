//
//  UpdateCardPINResponse.swift
//  AppO
//
//  Created by Abul Jaleel on 27/09/2024.
//


import Foundation

struct UpdateCardPINResponse: Codable {
    let acqInfo: AcqInfo?
    let issInfo: IssInfo?
    let cardInfo: CardInfo?
    let custInfo: CustInfo?
    let termInfo: TermInfo?
    let channelInfo: ChannelInfo?
    let acceptorInfo: AcceptorInfo?
    let txnInfo: TxnInfo?
    let securityInfo: SecurityInfo?
    let respInfo: InnerRespInfo?

    enum CodingKeys: String, CodingKey {
        case acqInfo = "acq_info"
        case issInfo = "iss_info"
        case cardInfo = "card_info"
        case custInfo = "cust_info"
        case termInfo = "term_info"
        case channelInfo = "channel_info"
        case acceptorInfo = "acceptor_info"
        case txnInfo = "txn_info"
        case securityInfo = "security_info"
        case respInfo = "resp_info"
    }
}

// MARK: - Acquirer Information
struct AcqInfo: Codable {
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

// MARK: - Issuer Information
struct IssInfo: Codable {
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

// MARK: - Card Information
struct CardInfo: Codable {
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

// MARK: - Customer Information
struct CustInfo: Codable {
    let custMobileNum: String?

    enum CodingKeys: String, CodingKey {
        case custMobileNum = "cust_mobile_num"
    }
}

// MARK: - Terminal Information
struct TermInfo: Codable {
    let termID: String?
    let termLoc: String?

    enum CodingKeys: String, CodingKey {
        case termID = "term_id"
        case termLoc = "term_loc"
    }
}

// MARK: - Channel Information
struct ChannelInfo: Codable {
    let channelName: String?

    enum CodingKeys: String, CodingKey {
        case channelName = "channel_name"
    }
}

// MARK: - Acceptor Information
struct AcceptorInfo: Codable {
    let acceptorID: String?
    let mcc: String?

    enum CodingKeys: String, CodingKey {
        case acceptorID = "acceptor_id"
        case mcc
    }
}

// MARK: - Transaction Information
struct TxnInfo: Codable {
    let reqID: String?
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
        case reqID = "req_id"
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

// MARK: - Security Information
struct SecurityInfo: Codable {
    let pinBlock: String?
    let newPinBlock: String?
    let commKeyULmk: String?

    enum CodingKeys: String, CodingKey {
        case pinBlock = "pin_block"
        case newPinBlock = "new_pin_block"
        case commKeyULmk = "comm_key_u_lmk"
    }
}

// MARK: - Inner Response Info
struct InnerRespInfo: Codable {
    let respCode: String?
    let respDesc: String?
    let rejectCode: String?

    enum CodingKeys: String, CodingKey {
        case respCode = "resp_code"
        case respDesc = "resp_desc"
        case rejectCode = "reject_code"
    }
}
