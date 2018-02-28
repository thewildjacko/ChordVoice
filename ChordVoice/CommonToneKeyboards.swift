//
//  CommonToneKeyboards.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 2/6/18.
//  Copyright © 2018 Jake Smolowe. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

class CommonToneKeyboards {
    let vc = UIApplication.getPresentedViewController() as! ViewController
    
    func commonToneTriad(myKeyboard: Keyboard, tonic: Int, root: Int, third: Int, fifth: Int, triadNumber: Int) {
        myKeyboard.keys[root].backgroundColor = rootKeyHighlightColor
        myKeyboard.keys[tonic].borderColor = tonicBorderHighlightColor
        myKeyboard.keys[tonic].borderWidth = 2
        myKeyboard.keys[third].backgroundColor = thirdAndFifthHighlightColor
        myKeyboard.keys[fifth].backgroundColor = thirdAndFifthHighlightColor
        myKeyboard.triadNumber = triadNumber
    }
    
    func addMiniKBs() {
        let masterKeyboard = vc.masterKeyboard!
        let masterHighlightKey = vc.masterHighlightKey
        let highlightLockKey = masterKeyboard.keys[masterHighlightKey].keyType
        
        vc.addKeyboard(initialKey: 4, startingOctave: 3, numberOfKeys: 8, highlightLockKey: -1)
        vc.addKeyboard(initialKey: 4, startingOctave: 3, numberOfKeys: 8, highlightLockKey: -1)
        vc.addKeyboard(initialKey: 4, startingOctave: 3, numberOfKeys: 9, highlightLockKey: -1)
        vc.addKeyboard(initialKey: 4, startingOctave: 3, numberOfKeys: 7, highlightLockKey: -1)
        vc.addKeyboard(initialKey: 1, startingOctave: 3, numberOfKeys: 8, highlightLockKey: -1)
        vc.addKeyboard(initialKey: 1, startingOctave: 3, numberOfKeys: 7, highlightLockKey: -1)
        vc.addKeyboard(initialKey: 12, startingOctave: 3, numberOfKeys: 8, highlightLockKey: -1)
        vc.addKeyboard(initialKey: 10, startingOctave: 3, numberOfKeys: 7, highlightLockKey: -1)
        vc.addKeyboard(initialKey: 9, startingOctave: 3, numberOfKeys: 8, highlightLockKey: -1)
        vc.addKeyboard(initialKey: 9, startingOctave: 3, numberOfKeys: 8, highlightLockKey: -1)
    }
    
    func miniCTKBs() {
        commonToneTriad(myKeyboard: vc.keyboards[1], tonic: 0, root: 0, third: 4, fifth: 7, triadNumber: 1)
        commonToneTriad(myKeyboard: vc.keyboards[2], tonic: 0, root: 0, third: 3, fifth: 7, triadNumber: 2)
        commonToneTriad(myKeyboard: vc.keyboards[3], tonic: 0, root: 0, third: 4, fifth: 8, triadNumber: 3)
        commonToneTriad(myKeyboard: vc.keyboards[4], tonic: 0, root: 0, third: 3, fifth: 6, triadNumber: 4)
        commonToneTriad(myKeyboard: vc.keyboards[5], tonic: 3, root: 0, third: 3, fifth: 7, triadNumber: 5)
        commonToneTriad(myKeyboard: vc.keyboards[6], tonic: 3, root: 0, third: 3, fifth: 6, triadNumber: 6)
        commonToneTriad(myKeyboard: vc.keyboards[7], tonic: 4, root: 0, third: 4, fifth: 7, triadNumber: 7)
        commonToneTriad(myKeyboard: vc.keyboards[8], tonic: 6, root: 0, third: 3, fifth: 6, triadNumber: 8)
        commonToneTriad(myKeyboard: vc.keyboards[9], tonic: 7, root: 0, third: 4, fifth: 7, triadNumber: 9)
        commonToneTriad(myKeyboard: vc.keyboards[10], tonic: 7, root: 0, third: 3, fifth: 7, triadNumber: 10)
    }
    
    init() {

    }
}



