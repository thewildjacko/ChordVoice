//
//  Key.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 12/27/17.
//  Copyright © 2017 Jake Smolowe. All rights reserved.

// The key objects for each keyboard.

import UIKit
import AudioKit
import AudioKitUI

@IBDesignable class Key: UIView, UIGestureRecognizerDelegate {
    var keyType = 0
    /// 1 is A, 2 is A#/Bb, 3 is B ... 12 is G#/Ab
    
    var defaultBackgroundColor: UIColor = .clear
    var currentHighlight = 0
    var holding = false
    var wasHoldingWhenSwitched = false
    var prevChordIndex = 0
    var previousBackground = UIColor()
    var highlightLocked = false
    var parent: Keyboard!
    var note = MIDINoteNumber()
    var bnk1Note: MidiBankNote!
    var bnk2Note: MidiBankNote!
    var keyIndex = Int()
    var initialLocation = CGPoint()
    
    init() {
        super.init(frame: CGRect())
        self.previousBackground = defaultBackgroundColor
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // rounded bottom corners
    }

    func setParent() {
        if let parent = parentKeyboardView {
            self.parent = parent
        } else {
            print("Parent does not exist")
        }
    }
    
    func addKeyShadow(add: Bool) {
        if add {
            self.addShadow(ofColor: purpleShadow, radius: 10, offset: CGSize.zero, opacity: 1.0)
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        } else {
            self.addShadow(ofColor: .clear, radius: 0, offset: CGSize.zero, opacity: 0)
            self.layer.shadowPath = nil
        }
    }
    
    func printTraitColor(mode: Int, color: UIColor, theString: String) {
        var switcher = UIColor()
        var switcherString = String()
        var verb = String()
        var colorName = String()
        
        switch mode {
        case 1: // previousBackground
            switcher = previousBackground
            switcherString = "Prev background "
            verb = "was "
        case 2: // custom
            switcher = color
            switcherString = theString
            verb = "is "
        default:
            ()
        }
        
        switch switcher {
        case UIColor.white:
            colorName = "white"
        case UIColor.darkGray:
            colorName = "black"
        case UIColor.magenta:
            colorName = "pink"
        case UIColor.red:
            colorName = "red"
        case UIColor.cyan:
            colorName = "blue"
        case UIColor.green:
            colorName = "green"
        default:
            ()
        }
        
        print("\(switcherString)\(verb)\(colorName)")
    }
    
    func goHighlight(currentHighlightDelta: Int, newHighlightColor: UIColor) {
        currentHighlight += currentHighlightDelta
        backgroundColor = newHighlightColor
    }

    func printCurrentHighlight(doHighlight: Bool) {
        if doHighlight {
            print("Highlighted! Current highlight value is \(currentHighlight)")
        } else {
            print("Un-highlighted! Current highlight value is \(currentHighlight)")
        }
    }

    func borderIt(color: UIColor, width: CGFloat) {
        borderColor = color
        borderWidth = width
    }

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
