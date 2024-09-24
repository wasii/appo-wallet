////
////  CryptoUtils.swift
////  AppO
////
////  Created by Abul Jaleel on 24/09/2024.
////
//
//
//import Foundation
//import CommonCrypto
//
//class CryptoUtils {
//
//    // Converts a hex string to a byte array
//    static func hexStringToByteArray(_ hex: String) -> [UInt8] {
//        var bytes = [UInt8]()
//        var index = hex.startIndex
//        while index < hex.endIndex {
//            let byteString = hex[index..<hex.index(index, offsetBy: 2)]
//            let byte = UInt8(byteString, radix: 16)
//            bytes.append(byte!)
//            index = hex.index(index, offsetBy: 2)
//        }
//        return bytes
//    }
//
//    // Converts a byte array to a hex string
//    static func byteArrayToHexString(_ bytes: [UInt8]) -> String {
//        return bytes.map { String(format: "%02X", $0) }.joined()
//    }
//
//    // Constructs a 24-byte (192-bit) key from a 16-byte key
//    static func construct3DESKey(_ key: [UInt8]) -> [UInt8] {
//        if key.count != 16 {
//            fatalError("Key must be 16 bytes long")
//        }
//        var key24 = [UInt8](repeating: 0, count: 24)
//        key24[0..<16] = key[0..<16]
//        key24[16..<24] = key[0..<8]
//        return key24
//    }
//
//    // 3DES Encryption
//    static func encrypt3DES(hexData: String, hexKey: String) throws -> String {
//        let data = hexStringToByteArray(hexData)
//        let key = construct3DESKey(hexStringToByteArray(hexKey))
//        
//        var cryptor: CCCryptorRef?
//        let status = CCCryptorCreate(
//            CCCryptorOperation(kCCEncrypt),
//            CCAlgorithm(kCCAlgorithm3DES),
//            CCOptions(kCCOptionECBMode),
//            key, key.count,
//            nil,
//            &cryptor
//        )
//
//        guard status == kCCSuccess, let cryptor = cryptor else {
//            throw NSError(domain: "Encryption failed", code: Int(status), userInfo: nil)
//        }
//
//        var encryptedData = [UInt8](repeating: 0, count: data.count + kCCBlockSize3DES)
//        var outLength = 0
//        
//        let updateStatus = CCCryptorUpdate(
//            cryptor,
//            data, data.count,
//            &encryptedData, encryptedData.count,
//            &outLength
//        )
//        
//        guard updateStatus == kCCSuccess else {
//            throw NSError(domain: "Encryption failed", code: Int(updateStatus), userInfo: nil)
//        }
//        
//        encryptedData = Array(encryptedData[..<outLength])
//        CCCryptorRelease(cryptor)
//        
//        return byteArrayToHexString(encryptedData)
//    }
//
//    // 3DES Decryption
//    static func decrypt3DES(hexEncryptedData: String, hexKey: String) throws -> String {
//        let encryptedData = hexStringToByteArray(hexEncryptedData)
//        let key = construct3DESKey(hexStringToByteArray(hexKey))
//        
//        var cryptor: CCCryptorRef?
//        let status = CCCryptorCreate(
//            CCCryptorOperation(kCCDecrypt),
//            CCAlgorithm(kCCAlgorithm3DES),
//            CCOptions(kCCOptionECBMode),
//            key, key.count,
//            nil,
//            &cryptor
//        )
//
//        guard status == kCCSuccess, let cryptor = cryptor else {
//            throw NSError(domain: "Decryption failed", code: Int(status), userInfo: nil)
//        }
//
//        var decryptedData = [UInt8](repeating: 0, count: encryptedData.count + kCCBlockSize3DES)
//        var outLength = 0
//        
//        let updateStatus = CCCryptorUpdate(
//            cryptor,
//            encryptedData, encryptedData.count,
//            &decryptedData, decryptedData.count,
//            &outLength
//        )
//        
//        guard updateStatus == kCCSuccess else {
//            throw NSError(domain: "Decryption failed", code: Int(updateStatus), userInfo: nil)
//        }
//        
//        decryptedData = Array(decryptedData[..<outLength])
//        CCCryptorRelease(cryptor)
//        
//        return byteArrayToHexString(decryptedData)
//    }
//}
