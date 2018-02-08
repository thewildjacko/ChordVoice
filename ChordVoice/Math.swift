//
//  Math.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 2/8/18.
//  Copyright © 2018 Jake Smolowe. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }
}

let leftAng = CGFloat(180.0).toRadians()
let bottomAng = CGFloat(90.0).toRadians()
let rightAng = CGFloat(0.0).toRadians()
let topAng = CGFloat(270).toRadians()
