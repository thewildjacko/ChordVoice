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

func addKeyShadow(add: Bool, key: Key) {
    if add {
        key.addShadow(ofColor: purpleShadow, radius: 10, offset: CGSize.zero, opacity: 1.0)
        key.shadowPath = UIBezierPath(rect: key.bounds).cgPath
    } else {
        key.addShadow(ofColor: .clear, radius: 0, offset: CGSize.zero, opacity: 0)
        key.shadowPath = nil
    }
}

func highlightKeys(myKey: Key, myRoot: Key, highlightColor: CGColor, doHighlight: Bool) {
    
    let currentBackground = myKey.backgroundColor
    let defaultBackgroundColor = myKey.defaultBackgroundColor
    if doHighlight == true {
        myKey.previousBackground = currentBackground!
    }
    
    func printPrevBackground() {
        switch myKey.previousBackground {
        case white:
            print("Prev bkgnd was white")
        case darkGray:
            print("Prev bkgnd was black")
        case magenta:
            print("Prev bkgnd was pink")
        case red:
            print("Prev bkgnd was red")
        case cyan:
            print("Prev bkgnd was blue")
        default:
            ()
        }
    }
    
    func printHighlightColor() {
        switch highlightColor {
        case white:
            print("highlightColor is white")
        case darkGray:
            print("highlightColor is black")
        case magenta:
            print("highlightColor is pink")
        case red:
            print("highlightColor is red")
        case cyan:
            print("highlightColor is blue")
        case green:
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
    
    func goHighlight(currentHighlightDelta: Int, newHighlightColor: CGColor) {
        myKey.currentHighlight += currentHighlightDelta
        myKey.fillColor = newHighlightColor
    }
    
    func borderIt(color: CGColor, width: CGFloat) {
        myKey.borderColor = color
        myKey.borderWidth = width
    }
    
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
                    borderIt(color: black, width: 1)
                }
            case 2:
                if myKey.holding {
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: keyHighlightColor)
                    borderIt(color: black, width: 1)
                } else {
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: secondKeyHighlightColor)
                    if myKey.highlightLocked {
                        borderIt(color: tonicBorderHighlightColor, width: 4)
                    } else {
                        borderIt(color: black, width: 1)
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
                addKeyShadow(add: false, key: myKey)
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
                addKeyShadow(add: true, key: myKey)
            default:
                ()
            }
        }
    }
}
