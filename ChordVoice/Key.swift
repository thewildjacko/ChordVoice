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
    public func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}

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

public extension CAShapeLayer {
    public func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowRadius = radius
        shadowOpacity = opacity
    }
}

public extension CAShapeLayer {
    internal var parentKeyboardView: Keyboard? {
        return self.delegate as? Keyboard
    }
    
    /// SwifterSwift: y origin of layer
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// SwifterSwift: y origin of layer
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    /// SwifterSwift: origin of layer
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
    
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
}

class Key: CAShapeLayer {
    var keyType = 0
    /// 1 is A, 2 is A#/Bb, 3 is B ... 12 is G#/Ab
    
    var defaultBackgroundColor: CGColor = UIColor.clear.cgColor
    var currentHighlight = 0
    var isPlaying = false
    var holding = false
    var playCount = 0
    var previousBackground: CGColor!
    var highlightLocked = false
    var tag = Int()
    var touchPoint = CGPoint(x: -100, y: -100)
    
    func keyBorderPath(myWidth: CGFloat, widthMod: CGFloat) {
        let myPath = UIBezierPath()
        let arcRadius = self.height * 1/32
        let y = self.y
        let width = self.width
        let height = self.height
        let blackHeight = 52/91 * height
        let myWidthMod = myWidth / widthMod
        
        let offsets: Dictionary<Int, CGFloat> = [1: 20, 2: 3, 3: 24, 4: 14, 5: 9, 6: 19, 7: 5, 8: 23, 9: 13, 10: 11, 11: 16, 12: 7]
        let firstBlackKeyOffsets: Dictionary<Int, CGFloat> = [2: -3, 5: -9, 7: -5, 10: -11, 12: -7]
        let modifiedOffsets = offsets.mapValues { $0 * myWidthMod }
        let modifiedFBKOffsets = firstBlackKeyOffsets.mapValues { $0 * myWidthMod }

        switch keyType {
        case 4:
            myPath.move(to: CGPoint(x: 0, y: y))
            myPath.addLine(to: CGPoint(x: 0, y: self.height * 31/32))
            myPath.addArc(withCenter: CGPoint(x: arcRadius, y: height * 31/32), radius: arcRadius, startAngle: leftAng, endAngle: bottomAng, clockwise: false)
            myPath.addLine(to: CGPoint(x: width - arcRadius, y: self.height))
            myPath.addArc(withCenter: CGPoint(x: width - arcRadius, y: height - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: rightAng, clockwise: false)
            myPath.addLine(to: CGPoint(x: width, y: blackHeight))
            myPath.addLine(to: CGPoint(x: modifiedOffsets[4]! + arcRadius, y: blackHeight))
            myPath.addArc(withCenter: CGPoint(x: modifiedOffsets[4]! + arcRadius, y: blackHeight - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: leftAng, clockwise: true)
            myPath.addLine(to: CGPoint(x: modifiedOffsets[4]!, y: y))
            myPath.close()
            self.path = myPath.cgPath
            self.lineWidth = 5
            self.strokeColor = green
        default:
            ()
        }

        
//        self.path = myPath.cgPath
    }
}
