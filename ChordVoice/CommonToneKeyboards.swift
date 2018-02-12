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

func commonToneTriad(myKeyboard: Keyboard, tonic: Int, root: Int, third: Int, fifth: Int, triadNumber: Int) {
    myKeyboard.keys[root].backgroundColor = rootKeyHighlightColor
    myKeyboard.keys[tonic].borderColor = tonicBorderHighlightColor
    myKeyboard.keys[tonic].layer.borderWidth = 2
    myKeyboard.keys[third].backgroundColor = thirdAndFifthHighlightColor
    myKeyboard.keys[fifth].backgroundColor = thirdAndFifthHighlightColor
    myKeyboard.triadNumber = triadNumber
}
