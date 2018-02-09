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
    var masterKeyboard: Keyboard!
    var masterKeys = [Key]()
    var masterHighlightKey = Int()
    var chordCount = 0
    var chordBorders = [CAShapeLayer]()
    var masterChordBorders = [CAShapeLayer]()
    var chordBorderColors: [UIColor] = [darkerYellow, lightPurple, darkerGreen, .orange, darkerBlue]
    
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
//                    print(myRootMidiNote, my3rdMidiNote, my5thMidiNote)
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
        
        func toggleBorders(myBorderLayer: CAShapeLayer, color: CGColor, opacity: Float) {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            myBorderLayer.strokeColor = color
            myBorderLayer.fillColor = color
            myBorderLayer.opacity = opacity
            CATransaction.commit()
        }
        
        func toggleBordersAndNote(note1: Int, note2: Int, noteOn: Bool, myColor: UIColor) {
            var myNote = MIDINoteNumber()
            
            func ifNegative(note: Int) -> MIDINoteNumber {
                if note > 0 {
                    myNote = lockedPitch + MIDINoteNumber(note)
                } else {
                    myNote = lockedPitch - MIDINoteNumber(abs(note))
                }
                return myNote
            }
            var color: CGColor!
            var opacity = Float()
            
            if noteOn {
                color = myColor.cgColor
                opacity = 0.5
                engine.noteOn(note: ifNegative(note: note1), bank: 2)
                engine.noteOn(note: ifNegative(note: note2), bank: 2)
            } else {
                color = clearColor.cgColor
                opacity = 0.0
                engine.noteOff(note: ifNegative(note: note1), bank: 2)
                engine.noteOff(note: ifNegative(note: note2), bank: 2)
            }
            toggleBorders(myBorderLayer: masterChordBorders[parent.triadNumber - 1], color: color, opacity: opacity)
//            print(parent.triadNumber)
        }
        
        if sender.state == .began {
            chordCount += 1
            parent.borderLayerColor = chordBorderColors[0]
            parent.borderLayer.fillColor = chordBorderColors[0].cgColor
            parent.borderLayer.opacity = 0.5
            let myColor = parent.borderLayerColor
//            printColorName(color: parent.borderLayerColor)
//            print(parent.keys[0].keyType)
            chordBorderColors.removeFirst()

            toggleBorders(myBorderLayer: parent.borderLayer, color: myColor.cgColor, opacity: 0.5)
//            parent.border.layer.borderColor = UIColor.red.cgColor
            engine.noteOn(note: lockedPitch, bank: 2)
            
            switch parent.triadNumber {
            case 1: // root major
                toggleBordersAndNote(note1: 4, note2: 7, noteOn: true, myColor: myColor)
            case 2: // root minor
                toggleBordersAndNote(note1: 3, note2: 7, noteOn: true, myColor: myColor)
            case 3: // root augmented
                toggleBordersAndNote(note1: 4, note2: 8, noteOn: true, myColor: myColor)
            case 4: // root diminished
                toggleBordersAndNote(note1: 3, note2: 6, noteOn: true, myColor: myColor)
            case 5: // min 3rd minor
                toggleBordersAndNote(note1: -3, note2: 4, noteOn: true, myColor: myColor)
            case 6: // min 3rd diminished
                toggleBordersAndNote(note1: -3, note2: 3, noteOn: true, myColor: myColor)
            case 7: // maj 3rd major
                toggleBordersAndNote(note1: -4, note2: 3, noteOn: true, myColor: myColor)
            case 8: // dim 5th diminished
                toggleBordersAndNote(note1: -6, note2: -3, noteOn: true, myColor: myColor)
            case 9: // P5 major
                toggleBordersAndNote(note1: -7, note2: -3, noteOn: true, myColor: myColor)
            case 10: // P5 minor
                toggleBordersAndNote(note1: -7, note2: -4, noteOn: true, myColor: myColor)
            default:
                ()
            }
        }
        
        if sender.state == .ended || sender.state == .cancelled {
            
            if sender.state == .ended {
                chordBorderColors.insert(parent.borderLayerColor, at: 0)
                parent.borderLayerColor = clearColor
                parent.borderLayer.fillColor = clearColor.cgColor
                parent.borderLayer.opacity = 0.0

                chordCount -= 1
                if chordCount == 0 {
                    chordBorderColors = [darkerYellow, lightPurple, darkerGreen, .orange, darkerBlue]
                }
            }
            
            if sender.state == .cancelled {
                chordBorderColors = [darkerYellow, lightPurple, darkerGreen, .orange, darkerBlue]
                chordCount = 0
            }
            
            toggleBorders(myBorderLayer: parent.borderLayer, color: clearColor.cgColor, opacity: 0.0)
            engine.noteOff(note: lockedPitch, bank: 2)
            
            switch parent.triadNumber {
            case 1: // root major
                toggleBordersAndNote(note1: 4, note2: 7, noteOn: false, myColor: clearColor)
            case 2: // root minor
                toggleBordersAndNote(note1: 3, note2: 7, noteOn: false, myColor: clearColor)
            case 3: // root augmented
                toggleBordersAndNote(note1: 4, note2: 8, noteOn: false, myColor: clearColor)
            case 4: // root diminished
                toggleBordersAndNote(note1: 3, note2: 6, noteOn: false, myColor: clearColor)
            case 5: // min 3rd minor
                toggleBordersAndNote(note1: -3, note2: 4, noteOn: false, myColor: clearColor)
            case 6: // min 3rd diminished
                toggleBordersAndNote(note1: -3, note2: 3, noteOn: false, myColor: clearColor)
            case 7: // maj 3rd major
                toggleBordersAndNote(note1: -4, note2: 3, noteOn: false, myColor: clearColor)
            case 8: // dim 5th diminished
                toggleBordersAndNote(note1: -6, note2: -3, noteOn: false, myColor: clearColor)
            case 9: // P5 major
                toggleBordersAndNote(note1: -7, note2: -3, noteOn: false, myColor: clearColor)
            case 10: // P5 minor
                toggleBordersAndNote(note1: -7, note2: -4, noteOn: false, myColor: clearColor)
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
    
    func edgeColors(key1: Key, key2: Key) -> Int {
        var edgeColors = 0
        switch key1.keyType {
        case 2, 5, 7, 10, 12: // 1st key is black
            switch key2.keyType {
            case 2, 5, 7, 10, 12: // last key is black
                edgeColors = 1
            case 1, 3, 4, 6, 8, 9, 11:
                edgeColors = 2 // last key is white
            default:
                ()
            }
        case 1, 3, 4, 6, 8, 9, 11: // 1st key is white
            switch key2.keyType {
            case 2, 5, 7, 10, 12: // last key is black
                edgeColors = 3
            case 1, 3, 4, 6, 8, 9, 11: // last key is white
                edgeColors = 4
            default:
                ()
            }
        default:
            ()
        }
        return edgeColors
    }
    
    func createBezier(key1Num: Int, key2Num: Int, key3Num: Int, key4Num: Int, myKeyboard: Keyboard) {
        myKeyboard.borderPath = UIBezierPath()
        
        let key1 = myKeyboard.keys[key1Num]
        let key2 = myKeyboard.keys[key2Num]
        let key3 = myKeyboard.keys[key3Num]
        let key4 = myKeyboard.keys[key4Num]
        
        let frame1 = myKeyboard.keys[key1Num].frame
        let frame2 = myKeyboard.keys[key2Num].frame
        let frame3 = myKeyboard.keys[key3Num].frame
        let frame4 = myKeyboard.keys[key4Num].frame
        
        let x1 = frame1.origin.x, y1 = frame1.origin.y, width1 = frame1.width, height1 = frame1.height
        let x2 = frame2.origin.x, y2 = frame2.origin.y, width2 = frame2.width, height2 = frame2.height
        let x3 = frame3.origin.x, y3 = frame3.origin.y, width3 = frame3.width, height3 = frame3.height
        let x4 = frame4.origin.x, y4 = frame4.origin.y, width4 = frame4.width, height4 = frame4.height
        
        let arcRadius = height1 * 1/32
        
        func startPath() {
            myKeyboard.borderPath.move(to: CGPoint(x: x1, y: y1))
            myKeyboard.borderPath.addLine(to: CGPoint(x: x1, y: height1 * 31/32))
            myKeyboard.borderPath.addArc(withCenter: CGPoint(x: x1 + arcRadius, y: height1 * 31/32), radius: arcRadius, startAngle: leftAng, endAngle: bottomAng, clockwise: false)
        }
        
        func leftIsBlack() {
            myKeyboard.borderPath.addLine(to: CGPoint(x: x2, y: height1))
            myKeyboard.borderPath.addLine(to: CGPoint(x: x2, y: height2 - arcRadius))
            myKeyboard.borderPath.addArc(withCenter: CGPoint(x: x2 + arcRadius, y: height2 - arcRadius), radius: arcRadius, startAngle: leftAng, endAngle: bottomAng, clockwise: false)
        }
        
        func rightIsBlack() {
            myKeyboard.borderPath.addLine(to: CGPoint(x: x3 + width3 - arcRadius, y: height3))
            myKeyboard.borderPath.addArc(withCenter: CGPoint(x: x3 + width3 - arcRadius, y: height3 - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: rightAng, clockwise: false)
            myKeyboard.borderPath.addLine(to: CGPoint(x: x3 + width3, y: height4))
        }
        
        func endPath() {
            myKeyboard.borderPath.addLine(to: CGPoint(x: x4 + width4 - arcRadius, y: height4))
            myKeyboard.borderPath.addArc(withCenter: CGPoint(x: x4 + width4 - arcRadius, y: height4 - arcRadius), radius: arcRadius, startAngle: bottomAng, endAngle: rightAng, clockwise: false)
            myKeyboard.borderPath.addLine(to: CGPoint(x: x4 + width4, y: y4))
            myKeyboard.borderPath.close()
        }
        
        func bothEdgeNotesBlack() {
            startPath()
            leftIsBlack()
            rightIsBlack()
            endPath()
        }
        
        func leftBlackRightWhite() {
            startPath()
            leftIsBlack()
            endPath()
        }
        
        func leftWhiteRightBlack() {
            startPath()
            rightIsBlack()
            endPath()
        }
        
        func bothEdgeNotesWhite() {
            startPath()
            endPath()
        }
        
        switch edgeColors(key1: key1, key2: key4) {
        case 1:
            bothEdgeNotesBlack()
        case 2:
            leftBlackRightWhite()
        case 3:
            leftWhiteRightBlack()
        case 4:
            bothEdgeNotesWhite()
        default:
            ()
        }
    }
    
    func borderBezier(key1Num: Int, key2Num: Int, key3Num: Int, key4Num: Int, myKeyboard: Keyboard) {
        createBezier(key1Num: key1Num, key2Num: key2Num, key3Num: key3Num, key4Num: key4Num, myKeyboard: myKeyboard)
        
        let borderLayer = CAShapeLayer()
        borderLayer.zPosition = 4
        borderLayer.path = myKeyboard.borderPath.cgPath
        
        borderLayer.fillColor = clearColor.cgColor
        borderLayer.strokeColor = clearColor.cgColor
        myKeyboard.borderLayer = borderLayer

        if myKeyboard.triadNumber > 0 {
            borderLayer.lineWidth = 4.0
            chordBorders.append(borderLayer)
            myKeyboard.layer.addSublayer(chordBorders[myKeyboard.triadNumber - 1])
            switch myKeyboard.triadNumber {
            case 1, 2: // root major, root minor
                borderBezier(key1Num: masterHighlightKey, key2Num: masterHighlightKey + 1, key3Num: masterHighlightKey + 6, key4Num: masterHighlightKey + 7, myKeyboard: masterKeyboard)
            case 3: // root augmented
                borderBezier(key1Num: masterHighlightKey, key2Num: masterHighlightKey + 1, key3Num: masterHighlightKey + 7, key4Num: masterHighlightKey + 8, myKeyboard: masterKeyboard)
            case 4: // root diminished
                borderBezier(key1Num: masterHighlightKey, key2Num: masterHighlightKey + 1, key3Num: masterHighlightKey + 5, key4Num: masterHighlightKey + 6, myKeyboard: masterKeyboard)
            case 5: // min 3rd minor
                borderBezier(key1Num: masterHighlightKey - 3, key2Num: masterHighlightKey - 2, key3Num: masterHighlightKey + 3, key4Num: masterHighlightKey + 4, myKeyboard: masterKeyboard)
            case 6: // min 3rd diminished
                borderBezier(key1Num: masterHighlightKey - 3, key2Num: masterHighlightKey - 2, key3Num: masterHighlightKey + 2, key4Num: masterHighlightKey + 3, myKeyboard: masterKeyboard)
            case 7: // maj 3rd major
                borderBezier(key1Num: masterHighlightKey - 4, key2Num: masterHighlightKey - 3, key3Num: masterHighlightKey + 2, key4Num: masterHighlightKey + 3, myKeyboard: masterKeyboard)
            case 8: // dim 5th diminished
                borderBezier(key1Num: masterHighlightKey - 6, key2Num: masterHighlightKey - 5, key3Num: masterHighlightKey - 1, key4Num: masterHighlightKey, myKeyboard: masterKeyboard)
            case 9, 10: // P5 major, // P5 minor
                borderBezier(key1Num: masterHighlightKey - 7, key2Num: masterHighlightKey - 6, key3Num: masterHighlightKey + 1, key4Num: masterHighlightKey, myKeyboard: masterKeyboard)
            default:
                ()
            }
            masterKeyboard.layer.addSublayer(masterChordBorders[myKeyboard.triadNumber - 1])
        } else {
            borderLayer.lineWidth = 8.0
            masterChordBorders.append(borderLayer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let screenWidth = view.frame.height
        let screenHeight = view.frame.width
        
        func addKeyboard(initialKey: Int, startingOctave: Int, numberOfKeys: Int, highlightLockKey: Int) {
            let myKeyboard = Keyboard(initialKey: initialKey, startingOctave: startingOctave, numberOfKeys: numberOfKeys)
            myKeyboard.highlightKey = highlightLockKey
            func tagAppendAndSort() {
                myKeyboard.tag = keyboardIndex
                //        print(myKeyboard.tag)
                if keyboards.count < 8 {
                    keyboardIndex += 1
                } else if keyboards.count == 8 {
                    keyboardIndex += 991
                } else {
                    keyboardIndex += 101
                }
                if highlightLockKey >= 0 {
                    masterKeyboard = myKeyboard
                    masterKeyboard.addKeys(highlightLockKey: highlightLockKey)
                    keyboards.append(masterKeyboard)
                    backgroundView.addSubview(masterKeyboard)
                } else {
                    myKeyboard.addKeys(highlightLockKey: highlightLockKey)
                    keyboards.append(myKeyboard)
                    backgroundView.addSubview(myKeyboard)
                }
            }
            tagAppendAndSort()
        }
        
        view.addSubview(backgroundView)
        backgroundView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
        view.sendSubview(toBack: backgroundView)
        
        addKeyboard(initialKey: 4, startingOctave: 2, numberOfKeys: 37, highlightLockKey: 12)
//        print(masterKeyboard.startingPitch)
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
        
        addTapGestureRecognizers(myKeyboard: masterKeyboard)
        
        keyboards[1...].forEach {addChordGestureRecognizers(myKeyboard: $0)}
    }
    
    override func viewWillLayoutSubviews() {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        // bottom keyboard
        masterKeyboard.frame = CGRect(x: 0, y: screenHeight - 91 / masterKeyboard.myKeyboardWidthMod * screenWidth, width: screenWidth, height: 91 / masterKeyboard.myKeyboardWidthMod * screenWidth)
        masterKeyboard.addKeyConstraints(keys: masterKeyboard.keys)
        
        if masterKeyboard.highlightPitch > 0 {
            masterKeyboard.keys[masterKeyboard.highlightKey].backgroundColor = tonicHighlightColor
            masterKeyboard.keys[masterKeyboard.highlightKey].defaultBackgroundColor = tonicHighlightColor
        }

        let heightAboveBottomKeyboard = screenHeight - masterKeyboard.frame.height
        
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
        
        masterKeys = masterKeyboard.keys
        masterHighlightKey = masterKeyboard.highlightKey
        
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
        
//        backgroundView.createLine(key1: masterKeyboard.keys[12], key2: Keyboard.keys[2], array: masterKeyboard.keys)
//        print(masterKeyboard.highlightPitch)
    }

    override func viewDidAppear(_ animated: Bool) {
        for keyboard in keyboards[1...] {
            borderBezier(key1Num: 0, key2Num: 1, key3Num: keyboard.keys.count - 2, key4Num: keyboard.keys.count - 1, myKeyboard: keyboard)
        }
        

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
