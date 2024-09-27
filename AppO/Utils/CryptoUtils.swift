//
//  CryptoUtils.swift
//  AppO
//
//  Created by Abul Jaleel on 24/09/2024.
//


import Foundation
import CommonCrypto

class CryptoUtils {
    
    static func hexStringToByteArray(_ hex: String) -> [UInt8] {
        var bytes = [UInt8]()
        var index = hex.startIndex
        while index < hex.endIndex {
            let byteString = hex[index..<hex.index(index, offsetBy: 2)]
            let byte = UInt8(byteString, radix: 16)!
            bytes.append(byte)
            index = hex.index(index, offsetBy: 2)
        }
        return bytes
    }
    
    static func bytesToHex(_ bytes: [UInt8]) -> String {
        return bytes.map { String(format: "%02x", $0) }.joined()
    }
    
    static func fix3DESKey(_ key: [UInt8]) -> [UInt8] {
        if key.count == 16 {
            return key + key[0..<8] // Extend to 24 bytes
        } else if key.count == 24 {
            return key
        } else {
            fatalError("Invalid key length. Must be 16 or 24 bytes.")
        }
    }
    
    static func encrypt3DES(key: [UInt8], data: [UInt8]) -> [UInt8]? {
        let fixedKey = fix3DESKey(key)
        return perform3DESCrypto(data: data, key: fixedKey, operation: CCOperation(kCCEncrypt))
    }
    
    static func decrypt3DES(key: [UInt8], data: [UInt8]) -> [UInt8]? {
        let fixedKey = fix3DESKey(key)
        return perform3DESCrypto(data: data, key: fixedKey, operation: CCOperation(kCCDecrypt))
    }
    
    static func perform3DESCrypto(data: [UInt8], key: [UInt8], operation: CCOperation) -> [UInt8]? {
        var outLength = Int(0)
        var output = [UInt8](repeating: 0, count: data.count + kCCBlockSize3DES)
        
        let status = CCCrypt(operation,
                             CCAlgorithm(kCCAlgorithm3DES),
                             CCOptions(kCCOptionECBMode),
                             key, kCCKeySize3DES,
                             nil,
                             data, data.count,
                             &output, output.count,
                             &outLength)
        
        guard status == kCCSuccess else { return nil }
        return Array(output.prefix(outLength))
    }
    
    static func generatePinBlock(pin: String, pan: String) -> [UInt8] {
        let pinBlock = "0\(pin.count)\(pin)" + String(repeating: "F", count: 14 - pin.count)
        let pinBlockBytes = hexStringToByteArray(pinBlock)
        
        let panBlock = "0000" + pan.suffix(13).dropLast()
        let panBlockBytes = hexStringToByteArray(String(panBlock))
        
        return zip(pinBlockBytes, panBlockBytes).map { $0 ^ $1 }
    }
    
    static func main() -> String?{
        // Step 1: Fetch DMK and verify the KCV
        let dmkHex = AppDefaults.dmk ?? "dmkHex"
        let dekHex = AppDefaults.dek ?? "dekHex"  // Encrypted DEK
        let dmkKcv = AppDefaults.dmk_kcv ?? "dmkKcv"
        let dekKcv = AppDefaults.dek_kcv ?? "dekKcv"
        
        print("DMK Hex: \(dmkHex)")
        print("DEK Hex (Encrypted): \(dekHex)")
        print("Expected DMK KCV: \(dmkKcv)")
        print("Expected DEK KCV: \(dekKcv)")
        
        let dmk = hexStringToByteArray(dmkHex)
        let encryptedDek = hexStringToByteArray(dekHex)
        let zeroBlock = hexStringToByteArray("0000000000000000")
        
        guard let encryptedDmk = encrypt3DES(key: dmk, data: zeroBlock) else { return nil}
        let dmkEncryptedKcv = bytesToHex(Array(encryptedDmk.prefix(8)))
        let isDmkValid = dmkEncryptedKcv == dmkKcv
        
        print("\nDMK Validation:")
        print("Zero Block for KCV: \(bytesToHex(zeroBlock))")
        print("Encrypted DMK KCV: \(dmkEncryptedKcv)")
        print("DMK validation successful? \(isDmkValid)\n")
        
        guard let clearDek = decrypt3DES(key: dmk, data: encryptedDek) else { return nil }
        guard let dekKcvData = encrypt3DES(key: clearDek, data: zeroBlock) else { return nil }
        let dekEncryptedKcv = bytesToHex(Array(dekKcvData.prefix(8)))
        let isDekValid = dekEncryptedKcv == dekKcv
        
        print("DEK Validation:")
        print("Clear DEK Byte Array: \(bytesToHex(clearDek))")
        print("Encrypted DEK KCV: \(dekEncryptedKcv)")
        print("DEK validation successful? \(isDekValid)\n")
        
        let pin = AppDefaults.temp_pin ?? "7766"  // New PIN
        let pan = AppDefaults.temp_cardnumber ?? "6367820020000712"  // PAN from which we'll extract the last 12 digits
        
        print("Generating ANSI PIN Block:")
        print("PIN: \(pin)")
        print("PAN: \(pan)")
        
        let pinBlock = generatePinBlock(pin: pin, pan: pan)
        
        print("Generated ANSI PIN Block (Clear): \(bytesToHex(pinBlock))\n")
        
        guard let encryptedPinBlock = encrypt3DES(key: clearDek, data: pinBlock) else { return nil }
        
        print("Encrypted ANSI PIN Block:")
        print("Encrypted PIN Block: \(bytesToHex(encryptedPinBlock))")
        
        return bytesToHex(encryptedPinBlock).uppercased()
    }
}
