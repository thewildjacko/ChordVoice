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

class Keyboard: UIView {
    
    let initialKey: Int
    let numberOfKeys: Int
    let startingOctave: Int
    var keys = [Key]()
    var whiteKeys = [Key]()
    var blackKeys = [Key]()
    var myLayoutConstraints = [NSLayoutConstraint]()
    var myKeyboardWidthMod: CGFloat = 0
    var startingPitch = Int()
    var highlightKey = Int()
    var highlightPitch = MIDINoteNumber()
    static var globalHighlightPitch = MIDINoteNumber()
    var triadNumber = Int()
    var borderPath: UIBezierPath!
    var borderLayer: CAShapeLayer!
    var borderLayerColor = UIColor()

    static var keyHighlightColor: UIColor = .red
    static var secondKeyHighlightColor: UIColor = .cyan
    static var secondKeyBorderColor: UIColor = .cyan
    static var shared3rdOr5thBorderColor: UIColor = .blue
    static var tonicHighlightColor: UIColor = .magenta
    static var tonicBorderHighlightColor: UIColor = .magenta
    static var rootKeyHighlightColor: UIColor = .green
    static var rootBorderHighlightColor: UIColor = .green
    static var thirdAndFifthHighlightColor: UIColor = .cyan
    
    var scale: CGFloat = 1.0
    
    init(initialKey: Int, startingOctave: Int, numberOfKeys: Int) {
        self.initialKey = initialKey
        self.startingOctave = startingOctave
        self.numberOfKeys = numberOfKeys
        self.startingPitch = initialKey + (startingOctave * 12) - 1
        super.init(frame: CGRect())
        //            self.backgroundColor = .red
        self.backgroundColor = .clear
    }
    
    func addKeys(highlightLockKey: Int) {
        var counter = initialKey
        
        while counter <= (numberOfKeys + initialKey - 1)   {
            var keyNum = Int()
            let timesIn = Int(counter/12)
            let key = Key()
            key.tag = "\(self.tag)\(counter - initialKey)".int!
            
            if counter <= 12 {
                keyNum = counter
            } else if counter > 12 && (counter % 12) != 0 {
                keyNum = counter - (12 * (timesIn))
            } else {
                keyNum = counter - (12 * (timesIn - 1))
            }
            
            key.keyType = keyNum
            switch keyNum {
            case 1, 4, 8, 11:
                myKeyboardWidthMod += 23
                whiteKeys.append(key)
            case 3, 6, 9:
                myKeyboardWidthMod += 24
                whiteKeys.append(key)
            case 2, 5, 7, 10, 12:
                blackKeys.append(key)
            default:
                print("Error!")
            }
            //                key.layer.opacity = 0.5
            keys.append(key)
            self.addSubview(key)
            key.setParent()
            key.note = MIDINoteNumber(startingPitch + counter - initialKey + 21)
// parent!.startingPitch + myTag + 21
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
    
    func addKeyConstraints(keys: [Key]) {
        
        for (index, key) in keys.enumerated() {
            key.translatesAutoresizingMaskIntoConstraints = false
            key.borderWidth = 1
            
            let myWidth = self.width
            
            var widthConstraints = NSLayoutConstraint()
            var heightConstraints = NSLayoutConstraint()
            var pinToPrevious = NSLayoutConstraint()
            var pinToLeftKeyboardEdge = NSLayoutConstraint()
            var pinToBottom = NSLayoutConstraint()
            var pinToTop = NSLayoutConstraint()
            //                key.cornerRadius = 5
            
            func setHighLightLockColor(key: Key, color: UIColor) {
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
            
            switch key.keyType {
            case 1, 4, 8, 11:
                key.layer.zPosition = 1
                setHighLightLockColor(key: key, color: .white)
//                key.defaultBackgroundColor = .white
                //                    key.backgroundColor = .blue
                key.backgroundColor = key.defaultBackgroundColor
                key.borderColor = .black
                if self.scale == 1 {
                    key.cornerRadius = 5.0
                } else {
                    key.cornerRadius = 10 * self.scale
                }
                
                
                widthConstraints = NSLayoutConstraint(item: key, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 23/myKeyboardWidthMod, constant: 0)
                heightConstraints = NSLayoutConstraint(item: key, attribute: .height, relatedBy: .equal, toItem: key, attribute: .width, multiplier: 91/23, constant: 0)
                pinToBottom = NSLayoutConstraint(item: key, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
                myLayoutConstraints += [widthConstraints, heightConstraints, pinToBottom]
                ()
            case 2, 5, 7, 10, 12:
                key.layer.zPosition = 2
                setHighLightLockColor(key: key, color: .darkGray)
//                key.defaultBackgroundColor = .darkGray
                self.bringSubview(toFront: key)
                //                    key.backgroundColor = .gray
                key.backgroundColor = key.defaultBackgroundColor
                key.borderColor = .black
                if self.scale == 1 {
                    key.cornerRadius = 2.5
                } else {
                    key.cornerRadius = 10 * self.scale
                }
                widthConstraints = NSLayoutConstraint(item: key, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 14/myKeyboardWidthMod, constant: 0)
                heightConstraints = NSLayoutConstraint(item: key, attribute: .height, relatedBy: .equal, toItem: key, attribute: .width, multiplier: 52/14, constant: 0)
                pinToTop = NSLayoutConstraint(item: key, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
                myLayoutConstraints += [widthConstraints, heightConstraints, pinToTop]
            case 3, 6, 9:
                key.layer.zPosition = 1
                key.defaultBackgroundColor = .white
                //                    key.backgroundColor = .green
                key.backgroundColor = key.defaultBackgroundColor
                key.borderColor = .black
                if self.scale == 1 {
                    key.cornerRadius = 5.0
                } else {
                    key.cornerRadius = 10 * self.scale
                }
                
                widthConstraints = NSLayoutConstraint(item: key, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 24/myKeyboardWidthMod, constant: 0)
                heightConstraints = NSLayoutConstraint(item: key, attribute: .height, relatedBy: .equal, toItem: key, attribute: .width, multiplier: 91/24, constant: 0)
                pinToBottom = NSLayoutConstraint(item: key, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
                myLayoutConstraints += [widthConstraints, heightConstraints, pinToBottom]
            default:
                print("Error!")
            }
            
            //                let timesIn = Int((index)/12)
            //                print("octave is \(timesIn)")
            
            if index != 0 {
                switch key.keyType {
                case 1, 3, 6, 8, 11:
                    if index != 1 {
                        pinToPrevious = NSLayoutConstraint(item: key, attribute: .leading, relatedBy: .equal, toItem: keys[index - 2], attribute: .trailing, multiplier: 1.0, constant: 0)
                        myLayoutConstraints += [pinToPrevious]
                    } else {
                        pinToLeftKeyboardEdge = NSLayoutConstraint(item: key, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
                        myLayoutConstraints += [pinToLeftKeyboardEdge]
                    }
                case 2, 5, 7, 10, 12:
                    let blackKeyOffsets: Dictionary<Int, CGFloat> = [2: 20, 5: 14, 7: 19, 10: 13, 12: 16]
                    pinToPrevious = NSLayoutConstraint(item: key, attribute: .leading, relatedBy: .equal, toItem: keys[index - 1], attribute: .leading, multiplier: 1.0, constant: myWidth * blackKeyOffsets[key.keyType]!/myKeyboardWidthMod)
                    myLayoutConstraints += [pinToPrevious]
                case 4, 9:
                    pinToPrevious = NSLayoutConstraint(item: key, attribute: .leading, relatedBy: .equal, toItem: keys[index - 1], attribute: .trailing, multiplier: 1.0, constant: 0)
                    myLayoutConstraints += [pinToPrevious]
                default:
                    print("Error!")
                }
            } else {
                switch key.keyType {
                case 1, 3, 4, 6, 8, 9, 11:
                    pinToLeftKeyboardEdge = NSLayoutConstraint(item: key, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
                    myLayoutConstraints += [pinToLeftKeyboardEdge]
                case 2, 5, 7, 10, 12:
                    let firstBlackKeyOffsets: Dictionary<Int, CGFloat> = [2: -3, 5: -9, 7: -5, 10: -11, 12: -7]
                    pinToLeftKeyboardEdge = NSLayoutConstraint(item: key, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: myWidth * firstBlackKeyOffsets[key.keyType]!/myKeyboardWidthMod)
                    myLayoutConstraints += [pinToLeftKeyboardEdge]
                default:
                    print("Error!")
                }
            }
        }
        
        NSLayoutConstraint.activate(myLayoutConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
