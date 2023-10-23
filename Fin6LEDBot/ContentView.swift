//
//  ContentView.swift
//  Fin6LEDBot
//
//  Created by jim kardach on 8/7/23.
//

import SwiftUI
import CoreBluetooth

struct PeripheralView: View {
    
    let peripheral: Peripheral
    
    var body: some View {
        Form {
            Text(peripheral.name)
            let formattedBat = String(format: "%.2fV", peripheral.battLevel)
            Text("rssi: \(peripheral.rssi)")
            Text("BattLevel: \(formattedBat)")
            Text("Connectable: \(peripheral.isConnectable)")
            Text("TimeStamp: \(peripheral.timeStamp.formatted())")
            Text("Tx Power Level: \(peripheral.TxPowerLevel)")
            Text("Add: \(peripheral.add)")
        }
    }
}

struct peripheralRow: View {
    let bleDevice: Peripheral
    
    var body: some View {
        HStack {
            Text(bleDevice.name)
            Spacer()
            Text(String(bleDevice.rssi))
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var bleManager = BLEManager()
    @State var ledConfigs = DartConfig()
    
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 10) {
                Text("Bluetooth Devices(\(self.bleManager.peripherals.count))")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                List(bleManager.peripherals, id: \.self) { bleDevice in
                    NavigationLink("\(bleDevice.name), rssi:\(bleDevice.rssi)", value: bleDevice)
                }
                .navigationDestination(for: Peripheral.self, destination: PeripheralView.init)
                if bleManager.isSwitchedOn {
                    Text("Bluetooth is switched on")
                        .foregroundColor(.green)
                } else {
                    Text("Bluetooth is off")
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .onAppear(perform: startUp)
            .refreshable {
                print("refreshing: \(self.bleManager.peripherals.count)")
                bleManager.rescan()
            }
        }
    }
    
    func startUp() {
        readDefaults()
    }
    
    func readDefaults() {
        if let savedConfig = UserDefaults.standard.value(forKey: "LedConfigs") as? Data {
            let decoder = JSONDecoder()
            if let ledConfigs = try? decoder.decode(DartConfig.self, from: savedConfig) {
                print("read ledConfigs")
            } else {
                print("decoding ledConfigs failed")
                ledConfigs = DartConfig()
                storeDefaults()
            }
        } else {
            ledConfigs.reinit() // reset all of the vlaues of ledconfig
            storeDefaults()
        }
    }
    // stores the ledConfigs to defaults
    func storeDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(ledConfigs) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "LedConfigs")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
