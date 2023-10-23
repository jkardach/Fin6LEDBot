//
//  LED.swift
//  Fin6LEDBot
//
//  Created by jim kardach on 8/7/23.
//
//  each instance can create colors via RGB, Hue, Saturation, brightness or HSB

import Foundation
import SwiftUI

struct LED: Codable {
    var name: String
    var red: Int = 255
    var green: Int = 255
    var blue: Int = 255
    var brightness: Int = 255
    
    
    init(name: String, red: Int, green: Int, blue: Int, brightness: Int) {
        self.name = name
        self.red = red
        self.green = green
        self.blue = blue
        self.brightness = brightness
    }
    
    // return the hue
    func getHue() -> Int {
        let hsb = getHSB()
        return Int(hsb.0 * 255.0)
    }
    // return the saturation
    func getSaturation() -> Int {
        let hsb = getHSB()
        return Int(hsb.1 * 255.0)
    }
    // return the hue
    func getBrightness() -> Int {
        let hsb = getHSB()
        return Int(hsb.2 * 255.0)
    }
    
    // converts the color to HSB format
    func getHSB() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let uiColor = UIColor(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0, alpha: 1)
        
        var hue: CGFloat  = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return (hue, saturation, brightness, alpha)
        }
}
