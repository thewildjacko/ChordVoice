//
//  Keyboard.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 12/27/17.
//  Copyright © 2017 Jake Smolowe. All rights reserved.
//
// A Keyboard wrapper for Key objects; includes methods to add Keys, set key type (A, B, C etc.), set layout constraints based on number of keys and initial key; also sets default highlight colors for keys.

import UIKit
import AudioKit
import AudioKitUI

class Keyboard: UIView, UIGestureRecognizerDelegate {
    
    let initialKey: Int
    let numberOfKeys: Int
    let startingOctave: Int
    var keys = [Key]()
    var whiteKeys = [Key]()
    var blackKeys = [Key]()
    
    let offsets: Dictionary<Int, CGFloat> = [1: 20, 2: 3, 3: 24, 4: 14, 5: 9, 6: 19, 7: 5, 8: 23, 9: 13, 10: 11, 11: 16, 12: 7]
    let firstBlackKeyOffsets: Dictionary<Int, CGFloat> = [2: -3, 5: -9, 7: -5, 10: -11, 12: -7]

    var myLayoutConstraints = [NSLayoutConstraint]()
    var myKeyboardWidthMod: CGFloat = 0
    var nextXPos: CGFloat = 0
    var startingPitch = Int()
    var highlightKey = Int()
    var highlightPitch = MIDINoteNumber()
    static var globalHighlightPitch = MIDINoteNumber()
    var triadNumber = Int()
    var keyboardBackgroundLayer = CAShapeLayer()
    var borderPath: UIBezierPath!
    var borderLayer: CAShapeLayer!
    var borderLayerColor = UIColor()
    var keyTapCount = 0
    var currentKeys = [Key]()
    var myBlackKeyHeight = CGFloat()

//    static var keyHighlightColor: UIColor = .red
//    static var secondKeyHighlightColor: UIColor = .cyan
//    static var secondKeyBorderColor: UIColor = .cyan
//    static var shared3rdOr5thBorderColor: UIColor = .blue
//    static var tonicHighlightColor: UIColor = .magenta
//    static var tonicBorderHighlightColor: UIColor = .magenta
//    static var rootKeyHighlightColor: UIColor = .green
//    static var rootBorderHighlightColor: UIColor = .green
//    static var thirdAndFifthHighlightColor: UIColor = .cyan
    
    static var keyHighlightColor: CGColor = red
    static var secondKeyHighlightColor: CGColor = cyan
    static var secondKeyBorderColor: CGColor = cyan
    static var shared3rdOr5thBorderColor: CGColor = blue
    static var tonicHighlightColor: CGColor = magenta
    static var tonicBorderHighlightColor: CGColor = magenta
    static var rootKeyHighlightColor: CGColor = green
    static var rootBorderHighlightColor: CGColor = green
    static var thirdAndFifthHighlightColor: CGColor = cyan
    
    var scale: CGFloat = 1.0
    var myTouchesBegan = [UITouch]()
    var myTouchesEnded = [UITouch]()
    var myTouchesCancelled = [UITouch]()
    var myTouchesMoved = [UITouch]()
    
    init(initialKey: Int, startingOctave: Int, numberOfKeys: Int) {
        self.initialKey = initialKey
        self.startingOctave = startingOctave
        self.numberOfKeys = numberOfKeys
        self.startingPitch = initialKey + (startingOctave * 12) - 1
        super.init(frame: CGRect())
        self.backgroundColor = .clear
        self.isMultipleTouchEnabled = true
    }

    var myPoints = [CGPoint]()
    var touchesKeyboardColors = [CGColor]()
    var touchedKeys = [Key]()
    
    func getPoint(keyTapCount: Int, remove: Bool, message: Int) {
//        switch message {
//        case 1:
////            print("hello from touches began")
//        case 2:
////            print("hello from touches ended")
//        case 3:
////            print("hello from touches moved")
//        default:
//            ()
//        }
        var myPoint = CGPoint()
        if myTouchesBegan.count > 0 {
            print("keyTapCount is \(keyTapCount)")
            print("myTouchesBegan.count is \(myTouchesBegan.count)")
            myPoint = myTouchesBegan[keyTapCount].location(in: self)
        }
        if remove {
            if myPoints.count > 0 && myTouchesBegan.count > 0 {
                myPoints.remove(at: keyTapCount)
                myTouchesBegan.remove(at: keyTapCount)
            }
        } else {
            myPoints.append(myPoint)
//            for key in self.keys {
//                var convertedPoint = CGPoint()
//                convertedPoint = keyboardBackgroundLayer.convert(myPoint, to: key)
//                //            print("myPoint is \(myPoint)")
//                //            print("convertedPoint is \(convertedPoint)")
//                if key.path?.contains(myPoint) == true {
//
//                    currentKeys.append(key)
//                }
//            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("Began!")
        print(self.keyboardBackgroundLayer.y)
        if let touch = touches.first {
            myTouchesBegan.append(touch)
            getPoint(keyTapCount: keyTapCount, remove: false, message: 1)
            keyTapCount += 1
            let tapLocation = touch.location(in: self)
            print("Location is \(tapLocation)")
            for (index, key) in self.keys.enumerated() {
                if key.hitTest(tapLocation) != nil {
//                    print("key \(index) tapped! Left x origin is \(key.x), bottom of key is \(key.y + key.height)")
                    touchesKeyboardColors.append(key.defaultBackgroundColor)
                    touchedKeys.append(key)
                    print("I matched! touchedKeys.count is \(touchedKeys.count)")
                    print(touchedKeys.count)
                    key.touchPoint = tapLocation
                    key.holding = true
                    instaHighlight(key: key, color: red)
                    break
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("Ended!")
        var myIndex = Int()
        if let touch = touches.first {
            for (theIndex, theTouch) in myTouchesBegan.enumerated() {
                if touch == theTouch {
                    myIndex = theIndex
//                    myTouchesBegan.remove(at: theIndex)
                }
            }

            let tapLocation = touch.location(in: self)
            for key in self.keys {
                if key.hitTest(tapLocation) != nil {
                    if key.holding {
                        instaHighlight(key: key, color: key.defaultBackgroundColor)
                        key.holding = false
                        getPoint(keyTapCount: myIndex, remove: true, message: 2)
                        keyTapCount -= 1
                    }
//                    print("key \(index) tap ended!")
                    break
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        var myPoint = CGPoint()
        var myIndex = Int()
        if let touch = touches.first {
            for (theIndex, theTouch) in myTouchesBegan.enumerated() {
                if touch == theTouch {
                    if myPoints.count > 0 {
                        myPoint = myPoints[theIndex]
                        myIndex = theIndex
                    }
                }
            }
//            print("myPoint[\(myIndex)] is \(myPoint)")
//            print("myTouchesBegan[\(myIndex)].location is \(myTouchesBegan[myIndex].location(in: self))")
            let tapLocation = touch.location(in: self)
            let last = touch.previousLocation(in: self)
            var thisKey = Key()
            var thisIndex = Int()
            var lastKey: Key!
            var lastIndex = Int()
//            print("tapLocation.y is \(tapLocation.y), self.y is \(self.y)")
//            print("tapLocation.x is \(tapLocation.x), left edge is \(self.x), right edge is \(self.width)")
            
            for (index, key) in self.keys.enumerated() {
                if key.hitTest(last) != nil {
                    lastKey = key
                    lastIndex = index
                }
                if key.hitTest(tapLocation) != nil {
                    thisKey = key
                    thisIndex = index
                }
            }

            var touchIndex = Int()
            if myTouchesBegan.count > 0 {
                for (index, myTouch) in myTouchesBegan.enumerated() {
                    if touch == myTouch {
                        touchIndex = index
                    }
                }
            }

            if tapLocation.y < 0 {
                print(keyTapCount)
                
                if let myLastKey = lastKey {
                    if touchedKeys.count > 0 {
                        print("Key is not nil")
                        print("Hey I'm switching back OK? My touch index is \(touchIndex). touchedKeys.count is \(touchedKeys.count)")
                        print(keyTapCount)
                        instaHighlight(key: lastKey, color: touchedKeys[touchIndex].defaultBackgroundColor)
                        lastKey.holding = false
                        touchedKeys.remove(at: myIndex)
                        print("myindex is \(myIndex)")
                        getPoint(keyTapCount: myIndex, remove: true, message: 3)
                        keyTapCount -= 1
                    }
                } else {
                    print("Key is nil")
                }
            } else {
                if thisKey != lastKey {
                    if let myLastKey = lastKey {
                        if lastKey.fillColor != lastKey.defaultBackgroundColor {
                            if touchedKeys.count > 0 {
                                print("Hey y is > 0, I'm switching back OK? My touch index is \(touchIndex). touchedKeys.count is \(touchedKeys.count)")
                                keyTapCount -= 1
                                print(keyTapCount)
                                instaHighlight(key: lastKey, color: lastKey.defaultBackgroundColor)
                                touchedKeys.remove(at: myIndex)
                                print("Now touchedKeys.count is \(touchedKeys.count)")
                                lastKey.holding = false
                                print("myindex is \(myIndex)")
                                getPoint(keyTapCount: myIndex, remove: true, message: 3)
                            }
                        }
                    } else {
                        print("Key is nil")
                    }
                }
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        print("Cancelled!")
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        super.touchesEstimatedPropertiesUpdated(touches)
    }
    
    func getKeyNum(counter: Int) -> Int {
        var keyNum = Int()
        let timesIn = Int(counter/12)
        
        if counter <= 12 {
            keyNum = counter
        } else if counter > 12 && (counter % 12) != 0 {
            keyNum = counter - (12 * (timesIn))
        } else {
            keyNum = counter - (12 * (timesIn - 1))
        }
//        print(keyNum)
        return keyNum
    }
    
    func addKeys(highlightLockKey: Int) {
        var counter = initialKey
        let layer = self.layer
        keyboardBackgroundLayer.frame = self.frame
        keyboardBackgroundLayer.bounds = self.bounds
        keyboardBackgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        keyboardBackgroundLayer.fillColor = clearColor.cgColor
        keyboardBackgroundLayer.strokeColor = clearColor.cgColor
        keyboardBackgroundLayer.lineWidth = 0
        keyboardBackgroundLayer.backgroundColor = clearColor.cgColor
        keyboardBackgroundLayer.zPosition = 0
        layer.addSublayer(keyboardBackgroundLayer)
        
        while counter <= (numberOfKeys + initialKey - 1)   {
            let keyNum = self.getKeyNum(counter: counter)
            let key = Key()
            key.tag = "\(self.tag)\(counter - initialKey)".int!
//            print("Hello \(key.tag)")
            key.keyType = keyNum
            switch keyNum {
            case 1, 4, 8, 11:
                myKeyboardWidthMod += 23
                whiteKeys.append(key)
                keyboardBackgroundLayer.insertSublayer(key, at: 0)
            case 3, 6, 9:
                myKeyboardWidthMod += 24
                whiteKeys.append(key)
                keyboardBackgroundLayer.insertSublayer(key, at: 0)
            case 2, 5, 7, 10, 12:
                blackKeys.append(key)
                keyboardBackgroundLayer.addSublayer(key)
            default:
                print("Error!")
            }
            //                key.layer.opacity = 0.5
            keys.append(key)
//            self.addSubview(key)
            
            
            counter += 1
        }
        if highlightLockKey > 0 {
            keys[highlightLockKey].highlightLocked = true
            keys[highlightLockKey].backgroundColor = Keyboard.tonicHighlightColor
            keys[highlightLockKey].defaultBackgroundColor = Keyboard.tonicHighlightColor
            self.highlightPitch = MIDINoteNumber(self.startingPitch + highlightLockKey + 21)
//            print(self.highlightPitch)
            Keyboard.globalHighlightPitch = self.highlightPitch
        } else {
            self.highlightPitch = Keyboard.globalHighlightPitch
        }
    }
    
    func setKeyDimensionsAndSpecs(keys: [Key], screenWidth: CGFloat) {
        
        for (index, key) in keys.enumerated() {
            key.borderWidth = 1
            var xPos = CGFloat()
            
            let myWidth = self.width
            let myHeight = self.height
            let scaleMod = myWidth / myKeyboardWidthMod
            let aCEGWidth = 23 * scaleMod
            let bDFWidth = 24 * scaleMod
            let blackKeyWidth = 14 * scaleMod
            let whiteKeyHeight = myHeight
            let blackKeyHeight = 52 / 91 * myHeight
            self.myBlackKeyHeight = blackKeyHeight
            
            func setHighLightLockColor(key: Key, color: CGColor) {
                if self.highlightKey > 0 {
                    if key == keys[highlightKey] {
                        key.backgroundColor = Keyboard.tonicHighlightColor
                        key.defaultBackgroundColor = Keyboard.tonicHighlightColor
                    } else {
                        key.backgroundColor = color
                        key.defaultBackgroundColor = color
                    }
                } else {
                    key.backgroundColor = color
                    key.defaultBackgroundColor = color
                }
            }
            
            func setX() {
                // 4: 14, 5: 9, 6: 19, 7: 5, 8: 23, 9: 20, 10: 13                
                let modifiedOffsets = offsets.mapValues { $0 * myWidth / myKeyboardWidthMod }
                let modifiedFBKOffsets = firstBlackKeyOffsets.mapValues { $0 * myWidth / myKeyboardWidthMod }
                
                if index != 0 {
                    xPos = nextXPos
                    nextXPos += modifiedOffsets[key.keyType]!
                } else {
                    switch key.keyType {
                    case 1, 3, 4, 6, 8, 9, 11:
                        xPos = 0
                    case 2, 5, 7, 10, 12:
                        xPos = modifiedFBKOffsets[key.keyType]!
                    default:
                        ()
                    }
                    nextXPos += xPos + modifiedOffsets[key.keyType]!
                }
            }
            
            setX()
            
            func setKeySpecs(zPos: CGFloat, hLColor: CGColor, borderColor: CGColor, cRadius: CGFloat, width: CGFloat, height: CGFloat) {
                key.zPosition = zPos
                setHighLightLockColor(key: key, color: hLColor)
                key.backgroundColor = key.defaultBackgroundColor
                key.fillColor = key.defaultBackgroundColor
                key.borderColor = borderColor
                key.previousBackground = key.defaultBackgroundColor
                key.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // rounded bottom corners

                if self.scale == 1 {
                    key.cornerRadius = cRadius
                } else {
                    key.cornerRadius = 10 * self.scale
                }
                
                key.frame = CGRect(x: xPos, y: 0, width: width, height: height)
                key.path = UIBezierPath(rect: key.bounds).cgPath
                key.keyBorderPath(myWidth: myWidth, widthMod: myKeyboardWidthMod)
//                print(key.x)
            }
            
            switch key.keyType {
            case 1, 4, 8, 11:
                setKeySpecs(zPos: 1, hLColor: white, borderColor: black, cRadius: 5.0, width: aCEGWidth, height: whiteKeyHeight)
            case 2, 5, 7, 10, 12:
                setKeySpecs(zPos: 2, hLColor: darkGray, borderColor: black, cRadius: 2.5, width: blackKeyWidth, height: blackKeyHeight)
            case 3, 6, 9:
                setKeySpecs(zPos: 1, hLColor: white, borderColor: black, cRadius: 5.0, width: bDFWidth, height: whiteKeyHeight)
            default:
                print("Error!")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
