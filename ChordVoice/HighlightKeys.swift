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
    
    printHighlightColor()
    
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
        printCurrentHighlight()
    }
    
    func borderIt(color: CGColor, width: CGFloat) {
        myKey.layer.borderColor = color
        myKey.layer.borderWidth = width
    }
    
    func addShadow(add: Bool) {
        if add {
            myKey.layer.shadowColor = purpleShadow.cgColor
            myKey.layer.shadowOpacity = 1
            myKey.layer.shadowOffset = CGSize.zero
            myKey.layer.shadowRadius = 10
            myKey.layer.shadowPath = UIBezierPath(rect: myKey.bounds).cgPath
        } else {
            myKey.layer.shadowColor = UIColor.clear.cgColor
            myKey.layer.shadowOpacity = 0
            myKey.layer.shadowOffset = CGSize.zero
            myKey.layer.shadowRadius = 0
            myKey.layer.shadowPath = nil
        }
    }
    
    if myKey.currentHighlight == 0 {
        printPrevBackground()
        goHighlight(currentHighlightDelta: 1, newHighlightColor: highlightColor)
        if myKey != myRoot && myKey.highlightLocked {
            borderIt(color: tonicBorderHighlightColor, width: 4)
        }
        if myKey.holding {
//            print("Key is highlighted 1x and holding.")
        } else {
//            print("Key is highlighted 1x but not holding.")
        }
    } else {
        if !doHighlight {
            switch myKey.currentHighlight {
            case 1:
                goHighlight(currentHighlightDelta: -1, newHighlightColor: myKey.defaultBackgroundColor)
                if myKey != myRoot && myKey.highlightLocked {
                    borderIt(color: blackBorder, width: 1)
                }
                if myKey.holding {
//                    print("Key is highlighted 1x and holding.")
                } else {
//                    print("Key is no longer highlighted or holding.")
                }
//                print("Key was highlighted 1x but is no longer playing.")
            case 2:
                if myKey.holding {
//                    print("doHighlight is false, currentHighlight is 2, key is holding")
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: keyHighlightColor)
                    borderIt(color: blackBorder, width: 1)
                } else {
//                    print("doHighlight is false, currentHighlight is 2, key is not holding")
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: secondKeyHighlightColor)
                    if myKey.highlightLocked {
                        borderIt(color: tonicBorderHighlightColor, width: 4)
                    } else {
                        borderIt(color: blackBorder, width: 1)
                    }
                }
            case 3:
                if myKey.holding {
                    if myKey == myRoot {
//                        print("Key losing highlight is the root! Key is holding. ")
                    } else {
//                        print("Key losing highlight is not the root!  Key is not holding.")
                    }
//                    print("doHighlight is false, currentHighlight is 3")
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: keyHighlightColor)
                    borderIt(color: secondKeyBorderColor, width: 4)
                } else {
                    if myKey == myRoot {
//                        print("Key losing highlight is the root! Key is not holding.")
//                        printPrevBackground()
                    } else {
//                        print("Key losing highlight is not the root! Key is not holding.")
                    }
//                    print("doHighlight is false, currentHighlight is 3")
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: secondKeyHighlightColor)
                    borderIt(color: shared3rdOr5thBorderColor, width: 4)
                }
            case 4:
                if myKey.holding {
                    if myKey == myRoot {
                        print("Key losing highlight is the root! Key is holding.")
                        printPrevBackground()
                    } else {
                        print("Key losing highlight is not the root! Key is holding.")
                    }
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: keyHighlightColor)
                    
//                    goHighlight(currentHighlightDelta: -1, newHighlightColor: UIColor.green)
                    borderIt(color: secondKeyBorderColor, width: 4)
                } else {
                    if myKey == myRoot {
                        print("Key losing highlight is the root! Key is not holding.")
                        printPrevBackground()
                    } else {
                        print("Key losing highlight is not the root! Key is not holding.")
                    }
                    goHighlight(currentHighlightDelta: -1, newHighlightColor: secondKeyHighlightColor)
//                    goHighlight(currentHighlightDelta: -1, newHighlightColor: UIColor.green)
                    borderIt(color: shared3rdOr5thBorderColor, width: 4)
                }
                addShadow(add: false)
            default:
                ()
            }
        } else {
            switch myKey.currentHighlight {
            case 1:
                printPrevBackground()
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
//                print("Highlighted 1x, highlighting again!")
                printCurrentHighlight()
            case 2:
//                print("Highlighted 2x, highlighting a third time!")
                if myKey == myRoot {
//                    print("3rd highlight as the root!")
                    goHighlight(currentHighlightDelta: 1, newHighlightColor: keyHighlightColor)
                    if myKey.holding {
                        borderIt(color: shared3rdOr5thBorderColor, width: 4)
                    }
                } else {
                    myKey.currentHighlight += 1
//                    print("3rd highlight as 3rd or 5th!")
                    printCurrentHighlight()
                    borderIt(color: shared3rdOr5thBorderColor, width: 4)
                }
            case 3:
                print("Highlighting a 4th time!")
                goHighlight(currentHighlightDelta: 1, newHighlightColor: keyHighlightColor)
                addShadow(add: true)
                if myKey == myRoot {
                    print("I'm highlighting the root!")
                } else {
                    print("I'm highlighting the 3rd or 5th!")
                }
            default:
                ()
            }
        }
    }
}
