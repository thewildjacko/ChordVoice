//
//  Custom Extensions.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 2/17/18.
//  Copyright © 2018 Jake Smolowe. All rights reserved.
//

import Foundation
import  UIKit
import  AudioKit
import AudioKitUI

// Colors

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

let processMagenta = UIColor(red: 0xFF, green: 0x00, blue: 0x90)
let rose = UIColor(red: 0xFF, green: 0x00, blue: 0x7F)
let hotMagenta = UIColor(red: 0xFF, green: 0x33, blue: 0xCC)
let darkCyan = UIColor(red: 0x00, green: 0x8B, blue: 0x8B)
let processCyan = UIColor(red: 0x00, green: 0xB7, blue: 0xEB)
let electricBlue = UIColor(red: 0x7D, green: 0xF9, blue: 0xFF)
let purpleShadow = UIColor(red: 0x80, green: 0x00, blue: 0xFF)
let lavender = UIColor(red: 0xE6, green: 0xE6, blue: 0xFA)
let lightPurple = UIColor(red: 0xCE, green: 0x63, blue: 0xFF)
let orange = UIColor(red: 0xFF, green: 0x7F, blue: 0x00)
let clearColor = UIColor.clear
let darkerGreen = UIColor(red: 0x23, green: 0x9C, blue: 0x04)
let darkerYellow = UIColor(red: 0xFF, green: 0xC8, blue: 0x24)
let darkerBlue = UIColor(red: 0x48, green: 0x6D, blue: 0xFF)

var keyHighlightColor: UIColor = .red
var secondKeyHighlightColor: UIColor = .cyan
var secondKeyBorderColor: UIColor = .cyan
var shared3rdOr5thBorderColor: UIColor = .blue
var tonicHighlightColor: UIColor = .magenta
var tonicBorderHighlightColor: UIColor = .magenta
var rootKeyHighlightColor: UIColor = .green
var rootBorderHighlightColor: UIColor = .green
var thirdAndFifthHighlightColor: UIColor = .cyan

func printColorName(color: UIColor) {
    switch color {
    case UIColor.blue:
        print("Color is blue")
    case UIColor.green:
        print("Color is green")
    case UIColor.purple:
        print("Color is purple")
    case orange:
        print("Color is orange")
    case UIColor.yellow:
        print("Color is yellow")
    default:
        ()
    }
}

// Math

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }
}

let leftAng = CGFloat(180.0).toRadians()
let bottomAng = CGFloat(90.0).toRadians()
let rightAng = CGFloat(0.0).toRadians()
let topAng = CGFloat(270).toRadians()

// UIView

public extension UIView {
    
    public func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
    
    internal var parentKeyboardView: Keyboard? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let keyboard = parentResponder as? Keyboard {
                return keyboard
            }
        }
        return nil
    }
    
    /// SwifterSwift: Size of view.
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = false
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
}
