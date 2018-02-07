//
//  Colors.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 2/5/18.
//  Copyright © 2018 Jake Smolowe. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

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
let orange = UIColor(red: 0xFF, green: 0x7F, blue: 0x00)

var blackBorder: CGColor = UIColor.black.cgColor
var keyHighlightColor: UIColor = .red
var secondKeyHighlightColor: UIColor = .cyan
var secondKeyBorderColor: CGColor = UIColor.cyan.cgColor
var shared3rdOr5thBorderColor: CGColor = UIColor.blue.cgColor
var tonicHighlightColor: UIColor = .magenta
var tonicBorderHighlightColor: CGColor = UIColor.magenta.cgColor
var rootKeyHighlightColor: UIColor = .green
var rootBorderHighlightColor: CGColor = UIColor.green.cgColor
var thirdAndFifthHighlightColor: UIColor = lavender

