//
//  Triad.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 2/23/18.
//  Copyright © 2018 Jake Smolowe. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

class Triad {
    var root: Int
    var inversion = 0
    var third = Int()
    var fifth = Int()
    var invThird = Int()
    var invFifth = Int()
    var defaultThird = Int()
    var defaultFifth = Int()
    var degrees = [Int]()
    var outerBounds = Int()
    var maxOuterBounds = Int()
    var rootPosOffset = 8
    var firstInvOffset = 5
    
    init(root: Int) {
        self.root = root
        self.third = root + Int.maj3rd
        self.fifth = root + Int.p5th
        self.defaultThird = third
        self.defaultFifth = fifth
        self.invThird = 12 - defaultThird
        self.invFifth = 12 - defaultFifth
        self.degrees = [root, self.defaultThird, self.defaultFifth]
        self.outerBounds = self.defaultFifth + 1
        self.maxOuterBounds = 10
    }
    
    func invert(inversion: Int) {
        self.inversion = inversion
        switch inversion {
        case 0:
            third = defaultThird
            fifth = defaultFifth
            degrees = [root, third, fifth]
            outerBounds = defaultFifth + 1
        case 1:
            third = root - (12 - defaultThird)
            fifth = root - (12 - defaultFifth)
            degrees = [root, third, fifth]
            outerBounds = abs(third) + 1
        case 2:
            third = defaultThird
            fifth = root - (12 - defaultFifth)
            degrees = [root, third, fifth]
            outerBounds = third - fifth + 1
        default:
            print("Couldn't invert!")
        }
    }
    
    func setDefaults() {
        defaultThird = third
        defaultFifth = fifth
        invThird = 12 - defaultThird
        invFifth = 12 - defaultFifth
    }
}

class MinorTriad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + Int.min3rd
        fifth = root + Int.p5th
        setDefaults()
        rootPosOffset = 8
        firstInvOffset = 4
        maxOuterBounds = 10
    }
}

class AugmentedTriad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + Int.maj3rd
        fifth = root + Int.aug5th
        setDefaults()
        rootPosOffset = 9
        firstInvOffset = 5
        maxOuterBounds = 9
    }
}

class DiminishedTriad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + Int.min3rd
        fifth = root + Int.tritone
        setDefaults()
        rootPosOffset = 7
        firstInvOffset = 4
        maxOuterBounds = 10
    }
}

class Sus4Triad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + Int.p4th // actually the 4th...
        fifth = root + Int.p5th
        setDefaults()
        rootPosOffset = 8
        firstInvOffset = 6
        maxOuterBounds = 11
    }
}

class Sus2Triad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + Int.maj2nd // actually the 2nd...
        fifth = root + Int.p5th
        setDefaults()
        rootPosOffset = 8
        firstInvOffset = 3
        maxOuterBounds = 11
    }
}
