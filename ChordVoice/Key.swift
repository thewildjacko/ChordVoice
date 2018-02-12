//
//  Key.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 12/27/17.
//  Copyright © 2017 Jake Smolowe. All rights reserved.
//
// The key objects for each keyboard.

import UIKit

public extension UIView {
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
}

class Key: UIView {
    var keyType = 0
    /// 1 is A, 2 is A#/Bb, 3 is B ... 12 is G#/Ab
    
    var defaultBackgroundColor: UIColor = .clear
    var currentHighlight = 0
    var isPlaying = false
    var holding = false
    var playCount = 0
    var previousBackground = UIColor()
    var highlightLocked = false
    
    init() {
        super.init(frame: CGRect())
        self.previousBackground = defaultBackgroundColor
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // rounded bottom corners
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
