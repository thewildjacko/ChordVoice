//
//  CommonToneKeyboards.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 2/5/18.
//  Copyright © 2018 Jake Smolowe. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

func addShadow(add: Bool, key: Key) {
    if add {
        key.layer.shadowColor = purpleShadow.cgColor
        key.layer.shadowOpacity = 1
        key.layer.shadowOffset = CGSize.zero
        key.layer.shadowRadius = 10
        key.layer.shadowPath = UIBezierPath(rect: key.bounds).cgPath
    } else {
        key.layer.shadowColor = UIColor.clear.cgColor
        key.layer.shadowOpacity = 0
        key.layer.shadowOffset = CGSize.zero
        key.layer.shadowRadius = 0
        key.layer.shadowPath = nil
    }
}

func highlightKeys(myKey: Key, myRoot: Key, highlightColor: UIColor, doHighlight: Bool) {
    
    let currentBackground = myKey.backgroundColor
    let defaultBackgroundColor = myKey.defaultBackgroundColor
    if doHighlight == true {
        myKey.previousBackground = currentBackground!
    }
    
    func printPrevBackground() {
        switch myKey.previousBackground {
        case UIColor.white:
            print("Prev bkgnd was white")
        case UIColor.darkGray:
            print("Prev bkgnd was black")
        case UIColor.magenta:
            print("Prev bkgnd was pink")
        case UIColor.red:
            print("Prev bkgnd was red")
        case UIColor.cyan:
            print("Prev bkgnd was blue")
        default:
            ()
        }
    }
    
    func printHighlightColor() {
        switch highlightColor {
        case UIColor.white:
            print("highlightColor is white")
        case UIColor.darkGray:
            print("highlightColor is black")
        case UIColor.magenta:
            print("highlightColor is pink")
        case UIColor.red:
            print("highlightColor is red")
        case UIColor.cyan:
            print("highlightColor is blue")
        case UIColor.green:
            print("highlightColor is green")
        default:
            ()
        }
    }
        
    func printCurrentHighlight() {
        if doHighlight {
            print("Highlighted! Current highlight value is \(myKey.currentHighlight)")
        } else {
            print("Un-highlighted! Current highlight value is \(myKey.currentHighlight)")
        }
    }
    
    func goHighlight(currentHighlightDelta: Int, newHighlightColor: UIColor) {
        myKey.currentHighlight += currentHighlightDelta
        myKey.backgroundColor = newHighlightColor
    }
    
    func borderIt(color: CGColor, width: CGFloat) {
        myKey.layer.borderColor = color
        myKey.layer.borderWidth = width
    }
    
//    func addShadow(add: Bool) {
//        if add {
//            myKey.layer.shadowColor = purpleShadow.cgColor
//            myKey.layer.shadowOpacity = 1
//            myKey.layer.shadowOffset = CGSize.zero
//            myKey.layer.shadowRadius = 10
//            myKey.layer.shadowPath = UIBezierPath(rect: myKey.bounds).cgPath
//        } else {
//            myKey.layer.shadowColor = UIColor.clear.cgColor
//            myKey.layer.shadowOpacity = 0
//            myKey.layer.shadowOffset = CGSize.zero
//            myKey.layer.shadowRadius = 0
//            myKey.layer.shadowPath = nil
//        }
//    }
    
    if myKey.currentHighlight == 0 {
        goHighlight(currentHighlightDelta: 1, newHighlightColor: highlightColor)
        if myKey != myRoot && myKey.highlightLocked {
            borderIt(color: tonicBorderHighlightColor, width: 4)
        }
    } else {
        if !doHighlight {
            switch myKey.currentHighlight {
            case 1:
                goHighlight(currentHighlightDelta: -1, newHighlightColor: myKey.defaultBackgroundColor)
                if myKey != myRoot && myKey.highlightLocked {
                    borderIt(color: blackBorder, width: 1)
                }
            case 2:
                if myKey.holding {
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: keyHighlightColor)
                    borderIt(color: blackBorder, width: 1)
                } else {
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: secondKeyHighlightColor)
                    if myKey.highlightLocked {
                        borderIt(color: tonicBorderHighlightColor, width: 4)
                    } else {
                        borderIt(color: blackBorder, width: 1)
                    }
                }
            case 3:
                if myKey.holding {
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: keyHighlightColor)
                    borderIt(color: secondKeyBorderColor, width: 4)
                } else {
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: secondKeyHighlightColor)
                    borderIt(color: shared3rdOr5thBorderColor, width: 4)
                }
            case 4:
                if myKey.holding {
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: keyHighlightColor)
                    borderIt(color: secondKeyBorderColor, width: 4)
                } else {
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: secondKeyHighlightColor)
                    borderIt(color: shared3rdOr5thBorderColor, width: 4)
                }
                addShadow(add: false, key: myKey)
            default:
                ()
            }
        } else {
            switch myKey.currentHighlight {
            case 1:
                if myKey == myRoot {
                    goHighlight(currentHighlightDelta: 1, newHighlightColor: keyHighlightColor)
                    borderIt(color: secondKeyBorderColor, width: 4)
                } else {
                    if !myKey.isPlaying {
                        goHighlight(currentHighlightDelta: 1, newHighlightColor: secondKeyHighlightColor)
                        borderIt(color: shared3rdOr5thBorderColor, width: 4)
                    } else {
                        goHighlight(currentHighlightDelta: 1, newHighlightColor: keyHighlightColor)
                        borderIt(color: secondKeyBorderColor, width: 4)
                    }
                }
            case 2:
                if myKey == myRoot {
                    goHighlight(currentHighlightDelta: 1, newHighlightColor: keyHighlightColor)
                    if myKey.holding {
                        borderIt(color: shared3rdOr5thBorderColor, width: 4)
                    }
                } else {
                    myKey.currentHighlight += 1
                    borderIt(color: shared3rdOr5thBorderColor, width: 4)
                }
            case 3:
                goHighlight(currentHighlightDelta: 1, newHighlightColor: keyHighlightColor)
                addShadow(add: true, key: myKey)
            default:
                ()
            }
        }
    }
}
