//
//  ViewController.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 12/27/17.
//  Copyright © 2017 Jake Smolowe. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class ViewController: UIViewController {
    
    @IBAction func setOrRemoveHighlights(_ sender: AnyObject) {
//        print(sender.tag)
        let myNSTag = NSString(string: String(sender.tag))
        if myNSTag == "200000" {
            tapIndex = -1
        } else {
            let myButtonTag = String(NSString(string: myNSTag.substring(from: 5)))
//            print(myButtonTag)
            tapIndex = Int(myButtonTag)!
        }
    }
    
    var tapIndex = 0
    var keyboardIndex = 1
    var keyboards = [Keyboard]()
    let engine = AudioEngine(waveform: AKTable(.sawtooth))
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if tapIndex != -1 {
            let view: UIView = sender.view!
            let parent: Keyboard = (sender.view?.superview! as! Keyboard)
            var myTagString: String = String(view.tag)
            var myTagCount = myTagString.count
            let myNSTag = NSString(string: myTagString)
            var myKeyboardTag: NSString
            if myTagCount <= 3 {
                myKeyboardTag = NSString(string: myNSTag.substring(to: 1)) as NSString
            } else {
                myKeyboardTag = NSString(string: myNSTag.substring(to: 2)) as NSString
            }
            let myKeyboardTagInt = Int(myKeyboardTag as String)! - 1
            
            let myKeyboard = self.keyboards[myKeyboardTagInt]
            let myCount = self.keyboards[myKeyboardTagInt].keys.count
            let myKeys = self.keyboards[myKeyboardTagInt].keys
            myTagString.remove(at: myTagString.startIndex)
            
            var myTag: Int
            
            if myKeyboard.tag < 1000 {
                myTag = Int(myTagString)!
                //            print("myTag is \(myTag)")
            } else {
                myTag = Int(String(NSString(string: myTagString).substring(from: 3)))!
                //            print("myTag is \(myTag)")
            }
            
            let unison = 0, min2nd = 1, maj2nd = 2, min3rd = 3, maj3rd = 4, P4th = 5, tritone = 6, P5th = 7, min6th = 8, maj6th = 9, min7th = 10, maj7th = 11, octave = 12
            let simpleIntervals = [unison, min2nd, maj2nd, min3rd, maj3rd, P4th, tritone, P5th, min6th, maj6th, min7th, maj7th, octave]
            
            // 0: single notes, 1: major triads, 2: minor triads, 3: aug triads, 4: dim triads, 5: sus4 triad, 6: sus2 triad
            
            let chordInversionOuterBounds = [1: [8, 9, 10], 2: [8, 10, 9], 3: [9, 9, 9], 4: [7, 10, 10], 5: [8, 8, 11], 6: [8, 11, 8]]
            let chordUpperOffsets = [1: [8, 5], 2: [8, 4], 3: [9, 5], 4: [7, 4], 5: [8, 6], 6: [8, 3]]
            let chordInversions = [1: [4, 7, 5, 8], 2: [3, 7, 5, 9], 3: [4, 8, 4, 8], 4: [3, 6, 6, 9], 5: [5, 7, 5, 7], 6: [2, 7, 5, 10]]

            let myRoot = myKeys[myTag]
            let midiRootOffset = parent.startingPitch + myTag + 21
            let myRootMidiNote = MIDINoteNumber(midiRootOffset)
            print("my tag is \(myTag), my midi note is \(myRootMidiNote)")
            
            var my3rd = Key()
            var my3rdMidiNote = MIDINoteNumber()

            var my5th = Key()
            var my5thMidiNote = MIDINoteNumber()
            
            func toggleChordShape(triadType: Int, addRemove: Bool) {
                let rootPosOffset = chordUpperOffsets[triadType]![0]
                let firstInvOffset = chordUpperOffsets[triadType]![1]
                let chord = chordInversions[triadType]
                
                let myChordInversionOuterBounds = chordInversionOuterBounds[triadType]!.sorted()
                
                func set3rdAnd5th() {
                    if myTag <= myCount - rootPosOffset {
                        my3rd = myKeys[myTag + chord![0]]
                        my5th = myKeys[myTag + chord![1]]
                        
                        my3rdMidiNote = MIDINoteNumber(midiRootOffset + chord![0])
                        my5thMidiNote = MIDINoteNumber(midiRootOffset + chord![1])
                    } else if myTag > myCount - rootPosOffset && myTag <= myCount - firstInvOffset {
                        my3rd = myKeys[myTag + chord![0]]
                        my5th = myKeys[myTag - chord![2]]
                    
                        my3rdMidiNote = MIDINoteNumber(midiRootOffset + chord![0])
                        my5thMidiNote = MIDINoteNumber(midiRootOffset - chord![2])
                    } else {
                        my3rd = myKeys[myTag - chord![3]]
                        my5th = myKeys[myTag - chord![2]]

                        my3rdMidiNote = MIDINoteNumber(midiRootOffset - chord![3])
                        my5thMidiNote = MIDINoteNumber(midiRootOffset - chord![2])
                    }
                }
                
                // addRemove == true, highlight; addRemove == false, remove highlights
                if addRemove {
                    myRoot.backgroundColor = myKeyboard.keyHighlightColor
                    if myCount - myChordInversionOuterBounds[2] > 0 {
                        //                    print("We can invert!")
                        set3rdAnd5th()
                        my3rd.backgroundColor = myKeyboard.secondKeyHighlightColor
                        my5th.backgroundColor = myKeyboard.secondKeyHighlightColor
                    }
                } else {
                    myRoot.backgroundColor = myRoot.defaultBackgroundColor
                    if myCount - myChordInversionOuterBounds[2] > 0 {
                        set3rdAnd5th()
                        my3rd.backgroundColor = my3rd.defaultBackgroundColor
                        my5th.backgroundColor = my5th.defaultBackgroundColor
                    }
                }
            }
            if sender.state == .began  {
    //                        print(myTag)
                engine.noteOn(note: myRootMidiNote)
                if tapIndex == 0 {
                    myRoot.backgroundColor = .magenta
                } else if tapIndex > 0 {
                    toggleChordShape(triadType: tapIndex, addRemove: true)
                    engine.noteOn(note: my3rdMidiNote)
                    engine.noteOn(note: my5thMidiNote)
                }
            }
            
            if sender.state == .ended {
                engine.noteOff(note: myRootMidiNote)
                if tapIndex == 0 {
                    myRoot.backgroundColor = myRoot.defaultBackgroundColor
                } else if tapIndex > 0 {
                    toggleChordShape(triadType: tapIndex, addRemove: false)
                    engine.noteOff(note: my3rdMidiNote)
                    engine.noteOff(note: my5thMidiNote)
                } else {
                    print("Error!")
                }
            }
        }
    }
    
    func addTapGestureRecognizers(myKeyboard: Keyboard) {
        func addLongTaps(myKeysArray: [Key]) {
            for key in myKeysArray {
                key.isUserInteractionEnabled = true
                let tap = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                tap.minimumPressDuration = 0
                key.addGestureRecognizer(tap)
            }
        }
        
        addLongTaps(myKeysArray: myKeyboard.whiteKeys)
        addLongTaps(myKeysArray: myKeyboard.blackKeys)
    }
    
    @objc func highlightKeyboard(_ sender: UITapGestureRecognizer) {
        let parent: Keyboard = (sender.view as! Keyboard)
        
        if sender.state == .began {
            if parent.keys[0].frame.origin.x != 0 {
                print(parent.keys[parent.keys.count - 1].frame.origin.x + parent.keys[parent.keys.count - 1].frame.width - parent.keys[0].frame.origin.x)
            } else {
                print(parent.keys[parent.keys.count - 1].frame.origin.x + parent.keys[parent.keys.count - 1].frame.width)
            }
//            print(parent.keys[0].frame.origin.x)
//            print(parent.keys[parent.keys.count - 1].frame.origin.x + parent.keys[parent.keys.count - 1].frame.width)
            parent.layer.borderWidth = 2
            parent.layer.borderColor = UIColor.red.cgColor
        }
        
        if sender.state == .ended {
            parent.layer.borderWidth = 0
            parent.layer.borderColor = UIColor.black.cgColor
        }

    }
    
    func addChordGestureRecognizers(myKeyboard: Keyboard) {
        myKeyboard.isUserInteractionEnabled = true
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(highlightKeyboard(_:)))
        tap.minimumPressDuration = 0
        myKeyboard.addGestureRecognizer(tap)
    }
    
    let backgroundView = BackgroundView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let screenWidth = view.frame.height
        let screenHeight = view.frame.width
        
        func addKeyboard(initialKey: Int, startingOctave: Int, numberOfKeys: Int) {
            let myKeyboard = Keyboard(initialKey: initialKey, startingOctave: startingOctave, numberOfKeys: numberOfKeys)
            myKeyboard.tag = keyboardIndex
            //        print(myKeyboard.tag)
            if keyboards.count < 8 {
                keyboardIndex += 1
            } else if keyboards.count == 8 {
                keyboardIndex += 991
            } else {
                keyboardIndex += 101
            }
            backgroundView.addSubview(myKeyboard)
            keyboards.append(myKeyboard)
            myKeyboard.addKeys()
        }
        
        view.addSubview(backgroundView)
        backgroundView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
        view.sendSubview(toBack: backgroundView)
        
        addKeyboard(initialKey: 4, startingOctave: 2, numberOfKeys: 37)
        print(keyboards[0].startingPitch)
        addKeyboard(initialKey: 4, startingOctave: 4, numberOfKeys: 8)
        addKeyboard(initialKey: 4, startingOctave: 4, numberOfKeys: 8)
        addKeyboard(initialKey: 4, startingOctave: 4, numberOfKeys: 9)
        addKeyboard(initialKey: 4, startingOctave: 4, numberOfKeys: 7)
        addKeyboard(initialKey: 1, startingOctave: 4, numberOfKeys: 8)
        addKeyboard(initialKey: 1, startingOctave: 4, numberOfKeys: 7)
        addKeyboard(initialKey: 12, startingOctave: 4, numberOfKeys: 8)
        addKeyboard(initialKey: 10, startingOctave: 4, numberOfKeys: 7)
        addKeyboard(initialKey: 9, startingOctave: 4, numberOfKeys: 8)
        addKeyboard(initialKey: 9, startingOctave: 4, numberOfKeys: 8)
        
        addTapGestureRecognizers(myKeyboard: keyboards[0])
        
        addChordGestureRecognizers(myKeyboard: keyboards[1])
        addChordGestureRecognizers(myKeyboard: keyboards[2])
        addChordGestureRecognizers(myKeyboard: keyboards[3])
        addChordGestureRecognizers(myKeyboard: keyboards[4])
        addChordGestureRecognizers(myKeyboard: keyboards[5])
        addChordGestureRecognizers(myKeyboard: keyboards[6])
        addChordGestureRecognizers(myKeyboard: keyboards[7])
        addChordGestureRecognizers(myKeyboard: keyboards[8])
        addChordGestureRecognizers(myKeyboard: keyboards[9])
        addChordGestureRecognizers(myKeyboard: keyboards[10])
    }
    
    override func viewWillLayoutSubviews() {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        // bottom keyboard
        keyboards[0].frame = CGRect(x: 0, y: screenHeight - 91 / keyboards[0].myKeyboardWidthMod * screenWidth, width: screenWidth, height: 91 / keyboards[0].myKeyboardWidthMod * screenWidth)
        keyboards[0].addKeyConstraints(keys: keyboards[0].keys)
        
        let heightAboveBottomKeyboard = screenHeight - keyboards[0].frame.height
        
        func scaleKeyboard(myKeyboard: Keyboard, scale: CGFloat, x: CGFloat, y: CGFloat, xCentered: Bool, yCentered: Bool) {
            myKeyboard.scale = scale
            let keyboardHeight = heightAboveBottomKeyboard * scale
            let centerYKeyboard = (heightAboveBottomKeyboard - keyboardHeight)/2
            
            if xCentered && yCentered {
                myKeyboard.frame = CGRect(x: (screenWidth - myKeyboard.myKeyboardWidthMod * keyboardHeight/91)/2, y: centerYKeyboard, width: myKeyboard.myKeyboardWidthMod * keyboardHeight/91, height: keyboardHeight)
            } else if xCentered {
                myKeyboard.frame = CGRect(x: (screenWidth - myKeyboard.myKeyboardWidthMod * keyboardHeight/91)/2, y: y, width: myKeyboard.myKeyboardWidthMod * keyboardHeight/91, height: keyboardHeight)
            } else if yCentered {
                myKeyboard.frame = CGRect(x: x, y: centerYKeyboard, width: myKeyboard.myKeyboardWidthMod * keyboardHeight/91, height: keyboardHeight)
            } else {
                myKeyboard.frame = CGRect(x: x, y: y, width: myKeyboard.myKeyboardWidthMod * keyboardHeight/91, height: keyboardHeight)
            }
            
            myKeyboard.addKeyConstraints(keys: myKeyboard.keys)
        }
        
        scaleKeyboard(myKeyboard: keyboards[1], scale: 1/5, x: 15, y: 75, xCentered: false, yCentered: false)
        scaleKeyboard(myKeyboard: keyboards[2], scale: 1/5, x: 145, y: 75, xCentered: false, yCentered: false)
        scaleKeyboard(myKeyboard: keyboards[3], scale: 1/5, x: 275, y: 75, xCentered: false, yCentered: false)
        scaleKeyboard(myKeyboard: keyboards[4], scale: 1/5, x: 415, y: 75, xCentered: false, yCentered: false)
        scaleKeyboard(myKeyboard: keyboards[5], scale: 1/5, x: 575, y: 75, xCentered: false, yCentered: false)
        scaleKeyboard(myKeyboard: keyboards[6], scale: 1/5, x: 15, y: 165, xCentered: false, yCentered: false)
        scaleKeyboard(myKeyboard: keyboards[7], scale: 1/5, x: 145, y: 165, xCentered: false, yCentered: false)
        scaleKeyboard(myKeyboard: keyboards[8], scale: 1/5, x: 275, y: 165, xCentered: false, yCentered: false)
        scaleKeyboard(myKeyboard: keyboards[9], scale: 1/5, x: 415, y: 165, xCentered: false, yCentered: false)
        scaleKeyboard(myKeyboard: keyboards[10], scale: 1/5, x: 575, y: 165, xCentered: false, yCentered: false)
        
        keyboards[0].keys[12].backgroundColor = keyboards[1].keyHighlightColor
        keyboards[0].keys[12].highlightLocked = true
        
        keyboards[1].keys[0].backgroundColor = .green
        keyboards[1].keys[0].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[1].keys[0].layer.borderWidth = 2
        keyboards[1].keys[4].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[1].keys[7].backgroundColor = keyboards[1].secondKeyHighlightColor
        
        keyboards[2].keys[0].backgroundColor = .green
        keyboards[2].keys[0].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[2].keys[0].layer.borderWidth = 2
        keyboards[2].keys[3].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[2].keys[7].backgroundColor = keyboards[1].secondKeyHighlightColor
        
        keyboards[3].keys[0].backgroundColor = .green
        keyboards[3].keys[0].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[3].keys[0].layer.borderWidth = 2
        keyboards[3].keys[4].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[3].keys[8].backgroundColor = keyboards[1].secondKeyHighlightColor
        
        keyboards[4].keys[0].backgroundColor = .green
        keyboards[4].keys[0].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[4].keys[0].layer.borderWidth = 2
        keyboards[4].keys[3].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[4].keys[6].backgroundColor = keyboards[1].secondKeyHighlightColor
        
        keyboards[5].keys[0].backgroundColor = .green
        keyboards[5].keys[3].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[5].keys[3].layer.borderWidth = 2
        keyboards[5].keys[3].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[5].keys[7].backgroundColor = keyboards[1].secondKeyHighlightColor
        
        keyboards[6].keys[0].backgroundColor = .green
        keyboards[6].keys[3].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[6].keys[3].layer.borderWidth = 2
        keyboards[6].keys[3].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[6].keys[6].backgroundColor = keyboards[1].secondKeyHighlightColor
        
        keyboards[7].keys[0].backgroundColor = .green
        keyboards[7].keys[4].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[7].keys[4].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[7].keys[4].layer.borderWidth = 2
        keyboards[7].keys[7].backgroundColor = keyboards[1].secondKeyHighlightColor
        
        keyboards[8].keys[0].backgroundColor = .green
        keyboards[8].keys[3].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[8].keys[6].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[8].keys[6].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[8].keys[6].layer.borderWidth = 2
        
        keyboards[9].keys[0].backgroundColor = .green
        keyboards[9].keys[4].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[9].keys[7].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[9].keys[7].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[9].keys[7].layer.borderWidth = 2
        
        keyboards[10].keys[0].backgroundColor = .green
        keyboards[10].keys[3].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[10].keys[7].backgroundColor = keyboards[1].secondKeyHighlightColor
        keyboards[10].keys[7].layer.borderColor = keyboards[1].keyHighlightColor.cgColor
        keyboards[10].keys[7].layer.borderWidth = 2
        
//        backgroundView.createLine(key1: keyboards[0].keys[12], key2: keyboards[1].keys[2], array: keyboards[0].keys)
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
