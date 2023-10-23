//
//  DartConfig.swift
//  Fin6LEDBot
//
//  Created by jim kardach on 8/7/23.
//

import Foundation

struct DartConfig: Codable {
    var configs = [LED]()
    var lastConfig: LED
    
    init() {
        // if not create new config
        let dart1 = LED(name: "Dart1", red: 255, green: 140, blue: 0, brightness: 100)
        let dart2 = LED(name: "Dart2", red: 105, green: 105, blue: 105, brightness: 100)
        let dart3 = LED(name: "Dart3", red: 192, green: 192, blue: 192, brightness: 100)
        let dart4 = LED(name: "Dart4", red: 30, green: 144, blue: 255, brightness: 100)
        let bg = LED(name: "Bg", red: 255, green: 0, blue: 255, brightness: 100)
        configs.append(dart1)
        configs.append(dart2)
        configs.append(dart3)
        configs.append(dart4)
        configs.append(bg)
        lastConfig = dart1
    }
    
    mutating func reinit() {
        configs.removeAll()
        let dart1 = LED(name: "Dart1", red: 255, green: 140, blue: 0, brightness: 100)
        let dart2 = LED(name: "Dart2", red: 105, green: 105, blue: 105, brightness: 100)
        let dart3 = LED(name: "Dart3", red: 192, green: 192, blue: 192, brightness: 100)
        let dart4 = LED(name: "Dart4", red: 30, green: 144, blue: 255, brightness: 100)
        let bg = LED(name: "Bg", red: 255, green: 0, blue: 255, brightness: 100)
        configs.append(dart1)
        configs.append(dart2)
        configs.append(dart3)
        configs.append(dart4)
        configs.append(bg)
        lastConfig = dart1
    }
    
    mutating func addLED(led: LED) {
        configs.append(led)
        lastConfig = led
    }
    
}
