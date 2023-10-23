//
//  BLEManager.swift
//  Fin6LEDBot
//
//  Created by jim kardach on 8/7/23.
//

import Foundation
import CoreBluetooth

struct Peripheral: Identifiable, Hashable {
    let id: UUID
    let name: String
    let rssi: Int
    let device: CBPeripheral
    let add: String
    let battLevel: Double
    let TxPowerLevel: Int
    let isConnectable: String
    let timeStamp: Date
    
    // connected state
    var activeDevice: CBPeripheral?
    var isConnected: Bool = false
    


}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate,
                  CBPeripheralDelegate {
    
    var myCentral: CBCentralManager!
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    
    let RBL_SERVICE_UUID = "713D0000-503E-4C75-BA94-3148F18D941E"
    let RBL_CHAR_TX_UUID = "713D0000-503E-4C75-BA94-3148F18D941E"
    let RBL_CHAR_RX_UUID = "713D0000-503E-4C75-BA94-3148F18D941E"
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isSwitchedOn = central.state == .poweredOn ? true : false
        
        switch central.state {
        case .poweredOn: print("Bluetooth is powered on")
            myCentral.scanForPeripherals(withServices: nil)
        case .poweredOff: print("Bluetooth is powered off")
        case .resetting: print("Bluetooth is resetting")
        case .unauthorized: print("Bluetooth is unauthorized")
        case .unknown: print("Bluetooth is in an unknown state")
        case .unsupported: print("Bluetooth is in an unsupported state")
        @unknown default:
            print("Bluetooth is in a non-known state")
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        // discovered device already, return
        if peripherals.contains(where: { $0.id == peripheral.identifier } ) {
            return
        }
        
        let peripheralName = peripheral.name ?? "Unknown"
        
        var addString = ""
        var batLevel = 0.0
        for add in advertisementData {

            if add.key == "kCBAdvDataManufacturerData" {
                var mfgData2 = [UInt8]()
                if let mfgData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
                    mfgData2.append(contentsOf: mfgData)
                    let index = mfgData2.count
                    let mfg1a = mfgData2[index - 2]
                    let mfg1b = Int(mfg1a)
                    let mfg2a = mfgData2[index - 3]
                    let mfg2b = Int(mfg2a)
                    if mfg1b == 5 && mfg2b == 5 {
                        // this is an IN100
                        let bat = Int(mfgData[index - 1])
                        batLevel = Double(bat) * 0.03125    // catching the IN100 has bettery
                    }
                }
            }
            
            addString += "\(add.key): \(add.value)\n"
        }
        
        let absoluteTime = advertisementData["kCBAdvDataTimestamp"] as? Double
        let timeStamp = Date.init(timeIntervalSinceReferenceDate: absoluteTime ?? 0)

        let TxPowerLevel = advertisementData["kCBAdvDataTxPowerLevel"] as? Int ?? 0
        let connectable  = advertisementData["kCBAdvDatalsConnectable"] as? Int ?? 0
        let isConnectable = connectable == 1 ? "Yes" : "No"
        
        let newPeripheral = Peripheral(id: peripheral.identifier,
                                       name: peripheralName, rssi: RSSI.intValue,
                                       device: peripheral, add: addString,
                                       battLevel: batLevel,
                                       TxPowerLevel: TxPowerLevel,
                                       isConnectable: isConnectable,
                                       timeStamp: timeStamp)
        
        //print(peripheral)
        if !peripherals.contains(where: { $0.id == peripheral.identifier } ) {
            peripherals.append(newPeripheral)
            peripherals.sort(by: { $0.rssi > $1.rssi })
        }
        
    }
    
    func startScanning() {
//        myCentral.scanForPeripherals(withServices: [CBUUID(string: "FE8F"),
//                                                               CBUUID(string: "65786365-6C70-6F69-6E74-2E636F6D0000")],
//                                                options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        myCentral.scanForPeripherals(withServices: [CBUUID(string: RBL_SERVICE_UUID)])
    }
    
    func stopScanning() {
        print("Stop Scanning")
        myCentral.stopScan()
    }
    
    func startAdvertising() {
        print("Start Advertising")
        //myCentral.ad
    }
    
    func rescan() {
        peripherals.removeAll()
    }
    
}
