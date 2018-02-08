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
    var highlightPitch = MIDINoteNumber()
    static var globalHighlightPitch = MIDINoteNumber()
    var triadNumber = Int()
    var border = UIView()
    var borderPath: UIBezierPath!
    var borderLayer: CAShapeLayer!
    
    static var blackBorder: CGColor = UIColor.black.cgColor
    static var keyHighlightColor: UIColor = .red
    static var secondKeyHighlightColor: UIColor = .cyan
    static var secondKeyBorderColor: CGColor = UIColor.cyan.cgColor
    static var shared3rdOr5thBorderColor: CGColor = UIColor.blue.cgColor
    static var tonicHighlightColor: UIColor = .magenta
    static var tonicBorderHighlightColor: CGColor = UIColor.magenta.cgColor
    static var rootKeyHighlightColor: UIColor = .green
    static var rootBorderHighlightColor: CGColor = UIColor.green.cgColor
    static var thirdAndFifthHighlightColor: UIColor = lavender
    
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
            key.tag = Int("\(self.tag)\(counter - initialKey)")!
            
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
            key.layer.borderWidth = 1
            
            let myWidth = self.frame.width
            
            var widthConstraints = NSLayoutConstraint()
            var heightConstraints = NSLayoutConstraint()
            var pinToPrevious = NSLayoutConstraint()
            var pinToLeftKeyboardEdge = NSLayoutConstraint()
            var pinToBottom = NSLayoutConstraint()
            var pinToTop = NSLayoutConstraint()
            //                key.layer.cornerRadius = 5
            
            switch key.keyType {
            case 1, 4, 8, 11:
                key.layer.zPosition = 1
                key.defaultBackgroundColor = .white
                //                    key.backgroundColor = .blue
                key.backgroundColor = key.defaultBackgroundColor
                key.layer.borderColor = UIColor.black.cgColor
                if self.scale == 1 {
                    key.layer.cornerRadius = 5.0
                } else {
                    key.layer.cornerRadius = 10 * self.scale
                }
                
                
                widthConstraints = NSLayoutConstraint(item: key, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 23/myKeyboardWidthMod, constant: 0)
                heightConstraints = NSLayoutConstraint(item: key, attribute: .height, relatedBy: .equal, toItem: key, attribute: .width, multiplier: 91/23, constant: 0)
                pinToBottom = NSLayoutConstraint(item: key, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
                myLayoutConstraints += [widthConstraints, heightConstraints, pinToBottom]
                ()
            case 2, 5, 7, 10, 12:
                key.layer.zPosition = 2
                key.defaultBackgroundColor = .darkGray
                self.bringSubview(toFront: key)
                //                    key.backgroundColor = .gray
                key.backgroundColor = key.defaultBackgroundColor
                key.layer.borderColor = UIColor.black.cgColor
                if self.scale == 1 {
                    key.layer.cornerRadius = 2.5
                } else {
                    key.layer.cornerRadius = 10 * self.scale
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
                key.layer.borderColor = UIColor.black.cgColor
                if self.scale == 1 {
                    key.layer.cornerRadius = 5.0
                } else {
                    key.layer.cornerRadius = 10 * self.scale
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
    
    func keyboardBorder(key1: Key, key2: Key) {
        let origin = key1.frame.origin
        let leftX = key1.frame.origin.x
        let rightX = key2.frame.origin.x + key2.frame.width
        let width = rightX - leftX
        let height = self.frame.height
        let size: CGSize = CGSize(width: width, height: height)
        let border = UIView()
        let borderFrame = CGRect(origin: origin, size: size)
        
        border.frame = borderFrame
        border.backgroundColor = .clear
        border.layer.borderColor = UIColor.clear.cgColor
        border.layer.borderWidth = 2
        border.layer.zPosition = 3
        self.border = border
        self.addSubview(border)
    }
    
    func createBezier(key1Num: Int, key2Num: Int, key3Num: Int, key4Num: Int) {
        borderPath = UIBezierPath()

        let key1 = self.keys[key1Num].frame
        let key2 = self.keys[key2Num].frame
        let key3 = self.keys[key3Num].frame
        let key4 = self.keys[key4Num].frame
        let arcRadius = key1.height * 1/32
        
        let start = CGPoint(x: key1.origin.x, y: key1.origin.y)
        
        func bothEdgeNotesBlack() {
            borderPath.move(to: start)
            borderPath.addLine(to: CGPoint(x: start.x, y: key1.height * 31/32))
            borderPath.addArc(withCenter: CGPoint(x: start.x + arcRadius, y: key1.height * 31/32), radius: arcRadius, startAngle: leftAng, endAngle: bottomAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key2.origin.x, y: key1.height))
            borderPath.addLine(to: CGPoint(x: key2.origin.x, y: key2.height - arcRadius))
            borderPath.addArc(withCenter: CGPoint(x: key2.origin.x + arcRadius, y: key2.height - arcRadius), radius: arcRadius, startAngle: leftAng, endAngle: bottomAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key3.origin.x + key3.width - arcRadius, y: key2.height))
            borderPath.addArc(withCenter: CGPoint(x: key3.origin.x + key3.width - arcRadius, y: key2.height - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: rightAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key3.origin.x + key3.width, y: key4.height))
            borderPath.addLine(to: CGPoint(x: key4.origin.x + key4.width - arcRadius, y: key4.height))
            borderPath.addArc(withCenter: CGPoint(x: key4.origin.x + key4.width - arcRadius, y: key4.height - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: rightAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key4.origin.x + key4.width, y: key4.origin.y))
            borderPath.close()
        }
        
        func leftBlackRightWhite() {
            borderPath.move(to: start)
            borderPath.addLine(to: CGPoint(x: start.x, y: key1.height * 31/32))
            borderPath.addArc(withCenter: CGPoint(x: start.x + arcRadius, y: key1.height * 31/32), radius: arcRadius, startAngle: leftAng, endAngle: bottomAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key2.origin.x, y: key1.height))
            borderPath.addLine(to: CGPoint(x: key2.origin.x, y: key2.height - arcRadius))
            borderPath.addArc(withCenter: CGPoint(x: key2.origin.x + arcRadius, y: key2.height - arcRadius), radius: arcRadius, startAngle: leftAng, endAngle: bottomAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key4.origin.x + key4.width - arcRadius, y: key4.height))
            borderPath.addArc(withCenter: CGPoint(x: key4.origin.x + key4.width - arcRadius, y: key4.height - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: rightAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key4.origin.x + key4.width, y: key4.origin.y))
            borderPath.close()
        }
        
        func leftWhiteRightBlack() {
            borderPath.move(to: start)
            borderPath.addLine(to: CGPoint(x: start.x, y: key1.height * 31/32))
            borderPath.addArc(withCenter: CGPoint(x: start.x + arcRadius, y: key1.height * 31/32), radius: arcRadius, startAngle: leftAng, endAngle: bottomAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key3.origin.x + key3.width - arcRadius, y: key3.height))
            borderPath.addArc(withCenter: CGPoint(x: key3.origin.x + key3.width - arcRadius, y: key3.height - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: rightAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key3.origin.x + key3.width, y: key4.height))
            borderPath.addLine(to: CGPoint(x: key4.origin.x + key4.width - arcRadius, y: key4.height))
            borderPath.addArc(withCenter: CGPoint(x: key4.origin.x + key4.width - arcRadius, y: key4.height - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: rightAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key4.origin.x + key4.width, y: key4.origin.y))
            borderPath.close()
        }
            
        func bothEdgeNotesWhite() {
            borderPath.move(to: start)
            borderPath.addLine(to: CGPoint(x: start.x, y: key1.height * 31/32))
            borderPath.addArc(withCenter: CGPoint(x: start.x + arcRadius, y: key1.height * 31/32), radius: arcRadius, startAngle: leftAng, endAngle: bottomAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key4.origin.x + key4.width - arcRadius, y: key4.height))
            borderPath.addArc(withCenter: CGPoint(x: key4.origin.x + key4.width - arcRadius, y: key4.height - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: rightAng, clockwise: false)
            borderPath.addLine(to: CGPoint(x: key4.origin.x + key4.width, y: key4.origin.y))
            borderPath.close()
        }
        
        switch self.keys[key1Num].keyType {
        case 2, 5, 7, 10, 12: // 1st key is black
            switch self.keys[key4Num].keyType {
                case 2, 5, 7, 10, 12: // last key is black
                bothEdgeNotesBlack()
            case 1, 3, 4, 6, 8, 9, 11:
                leftBlackRightWhite() // last key is white
            default:
                ()
            }
        case 1, 3, 4, 6, 8, 9, 11: // 1st key is white
            switch self.keys[key4Num].keyType {
            case 2, 5, 7, 10, 12: // last key is black
                leftWhiteRightBlack()
            case 1, 3, 4, 6, 8, 9, 11: // last key is white
                bothEdgeNotesWhite()
            default:
                ()
            }
        default:
            ()
        }
    }

    func borderBezier(key1Num: Int, key2Num: Int, key3Num: Int, key4Num: Int) {
        self.createBezier(key1Num: key1Num, key2Num: key2Num, key3Num: key3Num, key4Num: key4Num)
        
        let borderLayer = CAShapeLayer()
        borderLayer.zPosition = 4
        borderLayer.path = self.borderPath.cgPath
        
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.red.cgColor
        borderLayer.lineWidth = 3.0
        self.borderLayer = borderLayer
        self.layer.addSublayer(self.borderLayer)
    }
    
    func keyunion(key1: Key, key2: Key) {
        let keyFrame = key1.frame.union(key2.frame)
        let key = Key()
        key.frame = keyFrame
        key.backgroundColor = .yellow
        key.layer.borderColor = Keyboard.blackBorder
        key.layer.borderWidth = 2
        key.layer.zPosition = 3
        self.addSubview(key)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
