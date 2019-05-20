//
//  PeripheralManager.swift
//  Periperal
//
//  Created by YOHEI OKAYA on 2019/05/20.
//  Copyright © 2019 YOHEI OKAYA. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

class PeripheralManager: CBPeripheralManager {
    
    private static let sharedInstance = PeripheralManager()
    private let beaconIdentifier = "jp.co.houwa-js.test.blog"
    private let uuidString = "48534442-4C45-4144-80C0-1800FFFFFFF2"
    
    /**
     ペリフェラルとしてアドバタイジングを開始する
     */
    static func startAdvertising() {
        // delegateに代入すると CBPeripheralManagerDelegate のメソッドが呼び出される
        sharedInstance.delegate = sharedInstance
    }
}


// MARK: - CBPeripheralManagerDelegate

extension PeripheralManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        case .unsupported:
            print("Unsupported")
        case .unauthorized:
            print("Unauthorized")
        case .poweredOff:
            print("PoweredOff")
        case .poweredOn:
            print("PoweredOn")
            startAdvertisingWithPeripheralManager(manager: peripheral)
        @unknown default:
            fatalError()
        }
    }
    
    private func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        if let error = error {
            print("Failed to start advertising with error:\(error)")
        } else {
            print("Start advertising")
        }
    }
    
    /**
     ペリフェラルとしてアドバタイジングを開始する
     
     - parameter manager: CBPeripheralManagerDelegate から受け取れる CBPeripheralManager
     */
    private func startAdvertisingWithPeripheralManager(manager: CBPeripheralManager) {
        guard let proximityUUID = UUID(uuidString: uuidString) else {
            return
        }
        
        let beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, identifier: beaconIdentifier)
        let beaconPeripheralData: NSDictionary = beaconRegion.peripheralData(withMeasuredPower: nil)
        manager.startAdvertising(beaconPeripheralData as? [String: AnyObject])
    }
}

