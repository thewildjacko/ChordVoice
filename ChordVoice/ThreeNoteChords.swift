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
    var defaultThird = Int()
    var defaultFifth = Int()
    var degrees = [Int]()
    var outerBounds = Int()
    
    init(root: Int) {
        self.root = root
        self.third = root + 4
        self.fifth = root + 7
        self.defaultThird = third
        self.defaultFifth = fifth
        self.degrees = [root, self.defaultThird, self.defaultFifth]
        self.outerBounds = self.defaultFifth + 1
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
            third = root + defaultThird
            fifth = root - (12 - defaultFifth)
            degrees = [root, third, fifth]
            outerBounds = third - fifth + 1
        default:
            print("Couldn't invert!")
        }
    }
}

class MinorTriad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + 3
        fifth = root + 7
        defaultThird = third
        defaultFifth = fifth
    }
}

class AugmentedTriad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + 4
        fifth = root + 8
        defaultThird = third
        defaultFifth = fifth
    }
}

class DiminishedTriad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + 3
        fifth = root + 6
        defaultThird = third
        defaultFifth = fifth
    }
}

class Sus4Triad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + 5 // actually the 4th...
        fifth = root + 7
        defaultThird = third
        defaultFifth = fifth
    }
}

class Sus2Triad: Triad {
    override init(root: Int) {
        super.init(root: root)
        third = root + 2 // actually the 2nd...
        fifth = root + 7
        defaultThird = third
        defaultFifth = fifth
    }
}
