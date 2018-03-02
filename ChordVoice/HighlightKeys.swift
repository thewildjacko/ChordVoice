//
//  HighlightKeys.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 2/5/18.
//  Copyright © 2018 Jake Smolowe. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

extension Keyboard {
    func highlightKeys(key: Key, root: Key, highlightColor: UIColor, doHighlight: Bool) {
        
        let currentBackground = key.backgroundColor
        if doHighlight == true {
            key.previousBackground = currentBackground!
        }
        
        if key.currentHighlight == 0 {
            key.goHighlight(currentHighlightDelta: 1, newHighlightColor: highlightColor)
            if key != root && key.highlightLocked {
                key.borderIt(color: Keyboard.tonicBorderHighlightColor, width: 4)
            }
        } else {
            if !doHighlight {
                switch key.currentHighlight {
                case 1:
                    key.goHighlight(currentHighlightDelta: -1, newHighlightColor: key.defaultBackgroundColor)
                    if key != root && key.highlightLocked {
                        key.borderIt(color: .black, width: 1)
                    }
                case 2:
                    if key.holding {
                        //                    print("key \(key.keyIndex) is holding, current highlight is \(key.currentHighlight), switching back!")
                        key.goHighlight(currentHighlightDelta: -1, newHighlightColor: Keyboard.keyHighlightColor)
                        key.borderIt(color: .black, width: 1)
                    } else {
                        key.goHighlight(currentHighlightDelta: -1, newHighlightColor: Keyboard.secondKeyHighlightColor)
                        if key.highlightLocked {
                            key.borderIt(color: Keyboard.tonicBorderHighlightColor, width: 4)
                        } else {
                            key.borderIt(color: .black, width: 1)
                        }
                    }
                case 3:
                    if key.holding {
                        key.goHighlight(currentHighlightDelta: -1, newHighlightColor: Keyboard.keyHighlightColor)
                        key.borderIt(color: Keyboard.secondKeyBorderColor, width: 4)
                    } else {
                        key.goHighlight(currentHighlightDelta: -1, newHighlightColor: Keyboard.secondKeyHighlightColor)
                        key.borderIt(color: Keyboard.shared3rdOr5thBorderColor, width: 4)
                    }
                case 4:
                    if key.holding {
                        key.goHighlight(currentHighlightDelta: -1, newHighlightColor: Keyboard.keyHighlightColor)
                        key.borderIt(color: Keyboard.secondKeyBorderColor, width: 4)
                    } else {
                        key.goHighlight(currentHighlightDelta: -1, newHighlightColor: Keyboard.secondKeyHighlightColor)
                        key.borderIt(color: Keyboard.shared3rdOr5thBorderColor, width: 4)
                    }
                    key.addKeyShadow(add: false)
                default:
                    ()
                }
            } else {
                switch key.currentHighlight {
                case 1:
                    if key == root {
                        key.goHighlight(currentHighlightDelta: 1, newHighlightColor: Keyboard.keyHighlightColor)
                        key.borderIt(color: Keyboard.secondKeyBorderColor, width: 4)
                    } else {
                        if !key.holding {
                            key.goHighlight(currentHighlightDelta: 1, newHighlightColor: Keyboard.secondKeyHighlightColor)
                            key.borderIt(color: Keyboard.shared3rdOr5thBorderColor, width: 4)
                        } else {
                            key.goHighlight(currentHighlightDelta: 1, newHighlightColor: Keyboard.keyHighlightColor)
                            key.borderIt(color: Keyboard.secondKeyBorderColor, width: 4)
                        }
                    }
                case 2:
                    if key == root {
                        key.goHighlight(currentHighlightDelta: 1, newHighlightColor: Keyboard.keyHighlightColor)
                        if key.holding {
                            key.borderIt(color: Keyboard.shared3rdOr5thBorderColor, width: 4)
                        }
                    } else {
                        key.currentHighlight += 1
                        key.borderIt(color: Keyboard.shared3rdOr5thBorderColor, width: 4)
                    }
                case 3:
                    key.goHighlight(currentHighlightDelta: 1, newHighlightColor: Keyboard.keyHighlightColor)
                    key.addKeyShadow(add: true)
                default:
                    ()
                }
            }
        }
    }
}
