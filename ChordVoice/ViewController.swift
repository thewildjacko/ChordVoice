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
    let engine = AudioEngine(waveform1: AKTable(.sawtooth), waveform2: AKTable(.square))
    
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
                    print(myRootMidiNote, my3rdMidiNote, my5thMidiNote)
                }
                
                // addRemove == true, highlight; addRemove == false, remove highlights
                if addRemove {
                    highlightKeys(myKey: myRoot, myRoot: myRoot, highlightColor: keyHighlightColor, doHighlight: true)
                    myRoot.playCount += 1
                    if myCount - myChordInversionOuterBounds[2] > 0 {
                        //                    print("We can invert!")
                        set3rdAnd5th()
                        my3rd.playCount += 1
                        my5th.playCount += 1
                        highlightKeys(myKey: my3rd, myRoot: myRoot, highlightColor: secondKeyHighlightColor, doHighlight: true)
                        highlightKeys(myKey: my5th, myRoot: myRoot, highlightColor: secondKeyHighlightColor, doHighlight: true)
                    }
                } else {
                    highlightKeys(myKey: myRoot, myRoot: myRoot, highlightColor: keyHighlightColor, doHighlight: false)
                    myRoot.playCount -= 1
                    if myCount - myChordInversionOuterBounds[2] > 0 {
                        set3rdAnd5th()
                        my3rd.playCount -= 1
                        my5th.playCount -= 1
                        highlightKeys(myKey: my3rd, myRoot: myRoot, highlightColor: secondKeyHighlightColor, doHighlight: false)
                        highlightKeys(myKey: my5th, myRoot: myRoot, highlightColor: secondKeyHighlightColor, doHighlight: false)
                    }
                }
            }
            if sender.state == .began  {
//                print("my tag is \(myTag), my midi note is \(myRootMidiNote)")
                if !myRoot.holding {
                    engine.noteOn(note: myRootMidiNote, bank: 1)
                    myRoot.holding = true
                }
                if tapIndex == 0 {
                    myRoot.playCount += 1
                    highlightKeys(myKey: myRoot, myRoot: myRoot, highlightColor: keyHighlightColor, doHighlight: true)
                } else if tapIndex > 0 {
                    toggleChordShape(triadType: tapIndex, addRemove: true)
                    engine.noteOn(note: my3rdMidiNote, bank: 1)
                    engine.noteOn(note: my5thMidiNote, bank: 1)
                }
                myRoot.isPlaying = true
            }
            
            if sender.state == .ended {
                func ifNotHolding(note: Key, midiNote: MIDINoteNumber) {
                    if !note.holding {
                        engine.noteOff(note: midiNote, bank: 1)
                    }
                }

                myRoot.holding = false
                if myRoot.playCount == 1 {
                    engine.noteOff(note: myRootMidiNote, bank: 1)
                }
                if tapIndex == 0 {
                    highlightKeys(myKey: myRoot, myRoot: myRoot, highlightColor: keyHighlightColor, doHighlight: false)
                    myRoot.playCount -= 1
                } else if tapIndex > 0 {
                    toggleChordShape(triadType: tapIndex, addRemove: false)
                    ifNotHolding(note: my3rd, midiNote: my3rdMidiNote)
                    ifNotHolding(note: my5th, midiNote: my5thMidiNote)
                } else {
                    print("Error!")
                }
                myRoot.isPlaying = false
            }

            if sender.state == .cancelled {
                for (index, key) in myKeys.enumerated() {
                    cancelAll(key: key, midiNote: MIDINoteNumber(parent.startingPitch + index + 21), bank: 1)
                }
//                cancelAll(key: myRoot, midiNote: myRootMidiNote, bank: 1)
//                if tapIndex > 0 {
//                    cancelAll(key: my3rd, midiNote: my3rdMidiNote, bank: 1)
//                    cancelAll(key: my5th, midiNote: my5thMidiNote, bank: 1)
//                }
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
        let lockedPitch = parent.highlightPitch
//        print(lockedPitch)
        
        if sender.state == .began {
            parent.border.layer.borderColor = UIColor.red.cgColor
            engine.noteOn(note: lockedPitch, bank: 2)
            
            switch parent.triadNumber {
            case 1: // root major
                engine.noteOn(note: lockedPitch + 4, bank: 2)
                engine.noteOn(note: lockedPitch + 7, bank: 2)
            case 2: // root minor
                engine.noteOn(note: lockedPitch + 3, bank: 2)
                engine.noteOn(note: lockedPitch + 7, bank: 2)
            case 3: // root augmented
                engine.noteOn(note: lockedPitch + 4, bank: 2)
                engine.noteOn(note: lockedPitch + 8, bank: 2)
            case 4: // root diminished
                engine.noteOn(note: lockedPitch + 3, bank: 2)
                engine.noteOn(note: lockedPitch + 6, bank: 2)
            case 5: // min 3rd minor
                engine.noteOn(note: lockedPitch - 3, bank: 2)
                engine.noteOn(note: lockedPitch + 4, bank: 2)
            case 6: // min 3rd diminished
                engine.noteOn(note: lockedPitch - 3, bank: 2)
                engine.noteOn(note: lockedPitch + 3, bank: 2)
            case 7: // maj 3rd major
                engine.noteOn(note: lockedPitch - 4, bank: 2)
                engine.noteOn(note: lockedPitch + 3, bank: 2)
            case 8: // dim 5th diminished
                engine.noteOn(note: lockedPitch - 6, bank: 2)
                engine.noteOn(note: lockedPitch - 3, bank: 2)
            case 9: // P5 major
                engine.noteOn(note: lockedPitch - 7, bank: 2)
                engine.noteOn(note: lockedPitch - 3, bank: 2)
            case 10: // P5 minor
                engine.noteOn(note: lockedPitch - 7, bank: 2)
                engine.noteOn(note: lockedPitch - 4, bank: 2)
            default:
                ()
            }
        }
        
        if sender.state == .ended || sender.state == .cancelled {
            parent.border.layer.borderColor = UIColor.clear.cgColor
            engine.noteOff(note: lockedPitch, bank: 2)
            
            switch parent.triadNumber {
            case 1: // root major
                engine.noteOff(note: lockedPitch + 4, bank: 2)
                engine.noteOff(note: lockedPitch + 7, bank: 2)
            case 2: // root minor
                engine.noteOff(note: lockedPitch + 3, bank: 2)
                engine.noteOff(note: lockedPitch + 7, bank: 2)
            case 3: // root augmented
                engine.noteOff(note: lockedPitch + 4, bank: 2)
                engine.noteOff(note: lockedPitch + 8, bank: 2)
            case 4: // root diminished
                engine.noteOff(note: lockedPitch + 3, bank: 2)
                engine.noteOff(note: lockedPitch + 6, bank: 2)
            case 5: // min 3rd minor
                engine.noteOff(note: lockedPitch - 3, bank: 2)
                engine.noteOff(note: lockedPitch + 4, bank: 2)
            case 6: // min 3rd diminished
                engine.noteOff(note: lockedPitch - 3, bank: 2)
                engine.noteOff(note: lockedPitch + 3, bank: 2)
            case 7: // maj 3rd major
                engine.noteOff(note: lockedPitch - 4, bank: 2)
                engine.noteOff(note: lockedPitch + 3, bank: 2)
            case 8: // dim 5th diminished
                engine.noteOff(note: lockedPitch - 6, bank: 2)
                engine.noteOff(note: lockedPitch - 3, bank: 2)
            case 9: // P5 major
                engine.noteOff(note: lockedPitch - 7, bank: 2)
                engine.noteOff(note: lockedPitch - 3, bank: 2)
            case 10: // P5 minor
                engine.noteOff(note: lockedPitch - 7, bank: 2)
                engine.noteOff(note: lockedPitch - 4, bank: 2)
            default:
                ()
            }
        }
    }
    
    func addChordGestureRecognizers(myKeyboard: Keyboard) {
        myKeyboard.isUserInteractionEnabled = true
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(highlightKeyboard(_:)))
        tap.minimumPressDuration = 0
        myKeyboard.addGestureRecognizer(tap)
    }
    
    func cancelAll(key: Key, midiNote: MIDINoteNumber, bank: Int) {
        key.holding = false
        key.backgroundColor = key.defaultBackgroundColor
        key.layer.borderColor = blackBorder
        key.layer.borderWidth = 1
        key.isPlaying = false
        key.playCount = 0
        key.currentHighlight = 0
        addShadow(add: false, key: key)
        engine.noteOff(note: midiNote, bank: 1)
    }
    
    let backgroundView = BackgroundView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let screenWidth = view.frame.height
        let screenHeight = view.frame.width
        
        func addKeyboard(initialKey: Int, startingOctave: Int, numberOfKeys: Int, highlightLockKey: Int) {
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
            myKeyboard.addKeys(highlightLockKey: highlightLockKey)
            if highlightLockKey > 1 {
                
            }
        }
        
        view.addSubview(backgroundView)
        backgroundView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
        view.sendSubview(toBack: backgroundView)
        
        addKeyboard(initialKey: 4, startingOctave: 2, numberOfKeys: 37, highlightLockKey: 12)
//        print(keyboards[0].startingPitch)
        addKeyboard(initialKey: 4, startingOctave: 4, numberOfKeys: 8, highlightLockKey: -1)
        addKeyboard(initialKey: 4, startingOctave: 4, numberOfKeys: 8, highlightLockKey: -1)
        addKeyboard(initialKey: 4, startingOctave: 4, numberOfKeys: 9, highlightLockKey: -1)
        addKeyboard(initialKey: 4, startingOctave: 4, numberOfKeys: 7, highlightLockKey: -1)
        addKeyboard(initialKey: 1, startingOctave: 4, numberOfKeys: 8, highlightLockKey: -1)
        addKeyboard(initialKey: 1, startingOctave: 4, numberOfKeys: 7, highlightLockKey: -1)
        addKeyboard(initialKey: 12, startingOctave: 4, numberOfKeys: 8, highlightLockKey: -1)
        addKeyboard(initialKey: 10, startingOctave: 4, numberOfKeys: 7, highlightLockKey: -1)
        addKeyboard(initialKey: 9, startingOctave: 4, numberOfKeys: 8, highlightLockKey: -1)
        addKeyboard(initialKey: 9, startingOctave: 4, numberOfKeys: 8, highlightLockKey: -1)
        
        addTapGestureRecognizers(myKeyboard: keyboards[0])
        
        keyboards[1...].forEach {addChordGestureRecognizers(myKeyboard: $0)}
    }
    
    override func viewWillLayoutSubviews() {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        // bottom keyboard
        keyboards[0].frame = CGRect(x: 0, y: screenHeight - 91 / keyboards[0].myKeyboardWidthMod * screenWidth, width: screenWidth, height: 91 / keyboards[0].myKeyboardWidthMod * screenWidth)
        keyboards[0].addKeyConstraints(keys: keyboards[0].keys)
//        keyboards[0].keyunion(key1: keyboards[0].keys[0], key2: keyboards[0].keys[1])
        
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
        
        for keyboard in keyboards[1...] {
            keyboard.keyboardBorder(key1: keyboard.keys[0], key2: keyboard.keys[keyboard.keys.count - 1])
        }
        
        keyboards[0].keys[12].backgroundColor = tonicHighlightColor
//        keyboards[0].keys[12].highlightLocked = true
        keyboards[0].keys[12].defaultBackgroundColor = tonicHighlightColor
        
        commonToneTriad(myKeyboard: keyboards[1], tonic: 0, root: 0, third: 4, fifth: 7, triadNumber: 1)
        commonToneTriad(myKeyboard: keyboards[2], tonic: 0, root: 0, third: 3, fifth: 7, triadNumber: 2)
        commonToneTriad(myKeyboard: keyboards[3], tonic: 0, root: 0, third: 4, fifth: 8, triadNumber: 3)
        commonToneTriad(myKeyboard: keyboards[4], tonic: 0, root: 0, third: 3, fifth: 6, triadNumber: 4)
        commonToneTriad(myKeyboard: keyboards[5], tonic: 3, root: 0, third: 3, fifth: 7, triadNumber: 5)
        commonToneTriad(myKeyboard: keyboards[6], tonic: 3, root: 0, third: 3, fifth: 6, triadNumber: 6)
        commonToneTriad(myKeyboard: keyboards[7], tonic: 4, root: 0, third: 4, fifth: 7, triadNumber: 7)
        commonToneTriad(myKeyboard: keyboards[8], tonic: 6, root: 0, third: 3, fifth: 6, triadNumber: 8)
        commonToneTriad(myKeyboard: keyboards[9], tonic: 7, root: 0, third: 4, fifth: 7, triadNumber: 9)
        commonToneTriad(myKeyboard: keyboards[10], tonic: 7, root: 0, third: 3, fifth: 7, triadNumber: 10)
        
//        backgroundView.createLine(key1: keyboards[0].keys[12], key2: Keyboard.keys[2], array: keyboards[0].keys)
        
        keyboards[7].borderBezier(key1Num: 0, key2Num: 1, key3Num: keyboards[7].keys.count - 2, key4Num: keyboards[7].keys.count - 1)
        keyboards[0].borderBezier(key1Num: 8, key2Num: 9, key3Num: 14, key4Num: 15)
        keyboards[1].borderBezier(key1Num: 0, key2Num: 1, key3Num: keyboards[1].keys.count - 2, key4Num: keyboards[1].keys.count - 1)
        keyboards[8].borderBezier(key1Num: 0, key2Num: 1, key3Num: keyboards[8].keys.count - 2, key4Num: keyboards[8].keys.count - 1)
        keyboards[6].borderBezier(key1Num: 0, key2Num: 1, key3Num: keyboards[6].keys.count - 2, key4Num: keyboards[6].keys.count - 1)

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
