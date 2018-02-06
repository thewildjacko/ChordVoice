////
////  CommonToneKeyboards.swift
////  ChordVoice
////
////  Created by Jake Smolowe on 2/5/18.
////  Copyright © 2018 Jake Smolowe. All rights reserved.
////
//
//import Foundation
//import AudioKit
//import AudioKitUI
//
//func commonToneTriad(myKeyboard: Keyboard, tonic: Int, root: Int, third: Int, fifth: Int) {
//    myKeyboard.keys[root].backgroundColor = Keyboard.rootKeyHighlightColor
//    myKeyboard.keys[tonic].layer.borderColor = Keyboard.tonicBorderHighlightColor
//    myKeyboard.keys[tonic].layer.borderWidth = 2
//    myKeyboard.keys[third].backgroundColor = Keyboard.secondKeyHighlightColor
//    myKeyboard.keys[fifth].backgroundColor = Keyboard.secondKeyHighlightColor
//}
//
//func isHighlightLocked(myKey: Key, myRoot: Key, highlightColor: UIColor, doHighlight: Bool) {
//    let currentBackground = myKey.backgroundColor
//    if doHighlight == true {
//        myKey.previousBackground = currentBackground!
//    }
//    if myKey.highlightLocked {
//        if myKey.backgroundColor == myKey.defaultBackgroundColor {
//            //            print("Highlight!")
//            print("Key is pink!")
//            myKey.currentHighlight += 1
//            myKey.backgroundColor = highlightColor
//            if myKey == myRoot {
//                myKey.layer.borderColor = highlightColor.cgColor
//            }
//            //            } else {
//            //                if myKey.isPlaying {
//            //                    myKey.layer.borderColor = UIColor.blue.cgColor
//            //                    myKey.layer.borderWidth = 4
//            //                } else {
//            //                    myKey.layer.borderColor = Keyboard.tonicBorderHighlightColor
//            //                    myKey.layer.borderWidth = 4
//            //                }
//            //            }
//        } else {
//            if myKey.backgroundColor == UIColor.red {
//                print("Key is Red")
//                if !doHighlight {
//                    if myKey.currentHighlight == 1 {
//                        myKey.currentHighlight -= 1
//                        myKey.backgroundColor = myKey.defaultBackgroundColor
//                        myKey.layer.borderColor = Keyboard.tonicBorderHighlightColor
//                    }
//                }
//            } else {
//                print("Key is Blue")
//                if !doHighlight {
//                    if myKey.currentHighlight == 1 {
//                        myKey.currentHighlight -= 1
//                        myKey.backgroundColor = myKey.defaultBackgroundColor
//                        myKey.layer.borderColor = Keyboard.tonicBorderHighlightColor
//                    }
//                }
//            }
//        }
//        //
//        //            if !doHighlight {
//        ////                print("Un-highlight!")
//        //                switch myKey.currentHighlight {
//        //                case 1:
//        //                    print(myKey.currentHighlight)
//        //                    myKey.currentHighlight -= 1
//        //                    myKey.layer.borderColor = myKey.previousBackground.cgColor
//        //                    myKey.backgroundColor = myKey.defaultBackgroundColor
//        //                    myKey.layer.borderWidth = 1
//        //                case 2:
//        //                    print(myKey.currentHighlight)
//        //                    myKey.currentHighlight -= 1
//        //                    myKey.layer.borderColor = Keyboard.tonicBorderHighlightColor
//        //                    myKey.backgroundColor = myKey.previousBackground
//        //                case 3:
//        //                    print(myKey.currentHighlight)
//        //                    myKey.currentHighlight -= 1
//        //                    myKey.layer.borderColor = highlightColor.cgColor
//        //                    myKey.backgroundColor = myKey.previousBackground
//        //                default:
//        //                    ()
//        //                }
//        //
//        ////                if myKey.currentHighlight > 1 {
//        ////                    myKey.currentHighlight -= 1
//        ////                    myKey.layer.borderColor = highlightColor.cgColor
//        ////                    myKey.backgroundColor = myKey.previousBackground
//        ////                } else {
//        ////                    myKey.currentHighlight -= 1
//        ////                    myKey.layer.borderColor = myKey.previousBackground.cgColor
//        ////                    myKey.backgroundColor = myKey.defaultBackgroundColor
//        ////                    myKey.layer.borderWidth = 1
//        ////                }
//        //            } else {
//        ////                print("Highlight!")
//        //                myKey.currentHighlight += 1
//        //                if myKey.isPlaying {
//        //                    if myKey == myRoot {
//        //                        myKey.backgroundColor = Keyboard.keyHighlightColor
//        //                        myKey.layer.borderColor = myKey.previousBackground.cgColor
//        //                        myKey.layer.borderWidth = 4
//        //                    } else {
//        //                        myKey.backgroundColor = myKey.previousBackground
//        //                        myKey.layer.borderColor = highlightColor.cgColor
//        //                        myKey.layer.borderWidth = 4
//        //                    }
//        ////                    myKey.backgroundColor = highlightColor
//        ////                    myKey.layer.borderColor = myKey.previousBackground.cgColor
//        ////                    myKey.layer.borderWidth = 4
//        //                } /* else {
//        //                    myKey.backgroundColor = highlightColor
//        //                    myKey.layer.borderColor = Keyboard.tonicBorderHighlightColor
//        //                }*/
//        //            }
//        //        }
//        //        print(myKey.currentHighlight)
//    } else {
//
//        if myKey.backgroundColor == myKey.defaultBackgroundColor {
//            //            print("Highlight!")
//            myKey.currentHighlight += 1
//            myKey.backgroundColor = highlightColor
//        } else {
//            if !doHighlight {
//                //                print("Un-highlight!")
//                myKey.layer.borderColor = UIColor.black.cgColor
//                myKey.layer.borderWidth = 1
//                if myKey.currentHighlight > 1 {
//                    myKey.currentHighlight -= 1
//                    myKey.backgroundColor = myKey.previousBackground
//                } else {
//                    myKey.currentHighlight -= 1
//                    myKey.backgroundColor = myKey.defaultBackgroundColor
//                }
//            } else {
//                //                print("Highlight!")
//                myKey.currentHighlight += 1
//                myKey.backgroundColor = myKey.previousBackground
//                if myKey.isPlaying {
//                    if myKey == myRoot {
//                        myKey.backgroundColor = Keyboard.keyHighlightColor
//                        myKey.layer.borderColor = myKey.previousBackground.cgColor
//                        myKey.layer.borderWidth = 4
//                    } else {
//                        myKey.backgroundColor = myKey.previousBackground
//                        myKey.layer.borderColor = highlightColor.cgColor
//                        myKey.layer.borderWidth = 4
//                    }
//                }
//            }
//
//            //        print(myKey.currentHighlight)
//        }
//}
//
//
//
