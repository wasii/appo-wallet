//
//  PermissionServiceManager.swift
//  AppO
//
//  Created by Abul Jaleel on 23/09/2024.
//

import AVFoundation
import LocalAuthentication
import Photos
import UIKit

class PermissionServiceManager {
    
    // Function to check Camera Permission
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraStatus {
        case .authorized:
            completion(true) // Permission already granted
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    // Function to check Microphone (Audio) Permission
    func checkAudioPermission(completion: @escaping (Bool) -> Void) {
        let audioStatus = AVAudioSession.sharedInstance().recordPermission
        
        switch audioStatus {
        case .granted:
            completion(true) // Permission already granted
        case .undetermined:
            // Request permission
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                completion(granted)
            }
        case .denied:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    // Function to check Face ID Permission
    func checkFaceIDPermission(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if context.biometryType == .faceID {
                completion(true) // Face ID is available
            } else {
                completion(false) // Face ID not available
            }
        } else {
            completion(false) // Biometrics not available
        }
    }
}
