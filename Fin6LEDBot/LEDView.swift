//
//  LEDView.swift
//  Fin6LEDBot
//
//  Created by jim kardach on 8/7/23.
//
/*
 Enter here with a connected BLE peripherial
 
 ** New **
 Bluetooth protocol - all commands are three bytes:
 command, Data0, Data1:
 0x00: firmware version
 0x01: Start/Stop
 ```0- stop
 1- play
 0x02: Mode
 1- Darts on
 2- Darts blink
 3- dart banks run
 4- dart single led run
 5- dart duel led run
 6- dart broadway flash
 0x03: Dart 1: r, g
 0x04: Dart 1: b
 0x05: Dart 2: r, g
 0x06: Dart 2: b
 0x07: Dart 3: r, g
 0x08: Dart 3: b
 0x09: Dart 4: r, g
 0x0a: Dart 4: b
 0x0b: Dart 5: r, g
 0x0c: Dart 5: b
 0x0d: bg: r, g
 0x0e: bg: b

 0x0f: brightness (all)
 */

import SwiftUI

struct LEDView: View {
    let modes = ["All Off", "All On", "All Blink", "Running 2 Lights",
                 "Fire", "Broadway", "Show1", "All On Dart Color",
                 "Palette Show", "Rainbow Show"]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LEDView_Previews: PreviewProvider {
    static var previews: some View {
        LEDView()
    }
}
