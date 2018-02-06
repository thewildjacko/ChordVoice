//
//  Key.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 12/27/17.
//  Copyright © 2017 Jake Smolowe. All rights reserved.
//
// The key objects for each keyboard.

import UIKit

class Key: UIView {
    var keyType = 0
    /// 1 is A, 2 is A#/Bb, 3 is B ... 12 is G#/Ab
    
    var defaultBackgroundColor: UIColor = .clear
    var currentHighlight = 0
    var isPlaying = false
    var holding = false
    var playCount = 0
    var previousBackground = UIColor()
    var highlightLocked = false // Haven't set up yet...use to set a key so that it can't be unhighlighted, or so that the highlight colors are inverted.
    
    init() {
        super.init(frame: CGRect())
        self.previousBackground = defaultBackgroundColor
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // rounded bottom corners
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
