//  BackgroundView.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 12/27/17.
//  Copyright © 2017 Jake Smolowe. All rights reserved.


/// A wrapper view for the app; can set background color and create a line between two different keys. Still trying to work out the positional computations between keys on separate keyboards.


import UIKit

@IBDesignable class BackgroundView: UIView {

    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    func createLine(key1: Key, key2: Key, array: [Key]) {
        // takes two Key objects, draws a line from the top center of key1 to the bottom center of key2

        path = UIBezierPath()
        
//        for key in array {
////            print("key center is \(key.convert(key.center, to: self.superview!))")
//            print("key center is \(key.center), origin is \(key.origin)")
//        } // print out center coordinates for both key1 and key2
        
        let p1x = key1.center.x
        let p1y = key1.convert(key1.origin, to: self.superview!).y
        let p2x = key2.convert(key2.center, to: self.superview!).x
        let p2y = key2.convert(key2.origin, to: self.superview!).y + key2.height
        //            let p1 = key1.origin
        //            let p2 = key2.origin
        
        //            print(p1)
        path.move(to: CGPoint(x: p1x, y: p1y))
//        path.move(to: CGPoint(x: p1x, y: p1.y))
        path.addLine(to: CGPoint(x: p2x, y: p2y))
        path.close()
    }
    
    override func draw(_ rect: CGRect) {
        //            self.createLine()
        
//        UIColor.black.setFill()
//        path.fill()
//
//        UIColor.green.setStroke()
//        path.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
