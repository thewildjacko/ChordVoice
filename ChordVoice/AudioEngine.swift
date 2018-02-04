//
//  AudioEngine.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 2/3/18.
//  Copyright © 2018 Jake Smolowe. All rights reserved.
//

import Foundation
import AudioKit

// Create a class to handle the audio set up
class AudioEngine {
    
    // Declare your nodes as instance variables
    var bank = AKOscillatorBank()
    var waveform = AKTable()
    
    init(waveform: AKTable) {
        self.waveform = waveform
        self.bank = AKOscillatorBank(waveform: waveform, attackDuration: 0.0, decayDuration: 0.0, sustainLevel: 1.0, releaseDuration: 0.0, pitchBend: 0.0, vibratoDepth: 0.0, vibratoRate: 0.0)
        self.bank.rampTime = 0.0
        
        AudioKit.output = bank
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit failed to start!")
        }
    }
    
    func noteOn(note: MIDINoteNumber) {
        bank.play(noteNumber: note, velocity: 80, frequency: note.midiNoteToFrequency())
    }

    func noteOff(note: MIDINoteNumber) {
        bank.stop(noteNumber: note)
    }
}

// Create your engine and start the player
//let engine = AudioEngine()
//engine.player.play()

