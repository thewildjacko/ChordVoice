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
    var bank1 = AKOscillatorBank()
    var bank2 = AKOscillatorBank()
    var mixer = AKMixer()
    var waveform1 = AKTable()
    var waveform2 = AKTable()
    
    
    init(waveform1: AKTable, waveform2: AKTable) {
        self.waveform1 = waveform1
        self.waveform2 = waveform2
        self.bank1 = AKOscillatorBank(waveform: waveform1, attackDuration: 0.0, decayDuration: 0.0, sustainLevel: 1.0, releaseDuration: 0.0, pitchBend: 0.0, vibratoDepth: 0.0, vibratoRate: 0.0)
        self.bank1.rampTime = 0.0
        self.bank2 = AKOscillatorBank(waveform: waveform2, attackDuration: 0.0, decayDuration: 0.0, sustainLevel: 1.0, releaseDuration: 0.0, pitchBend: 0.0, vibratoDepth: 0.0, vibratoRate: 0.0)
        self.bank2.rampTime = 0.0
        self.mixer = AKMixer(bank1, bank2)
        
        AudioKit.output = mixer
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit failed to start!")
        }
    }
    
    func noteOn(note: MIDINoteNumber, bank: Int) {
        switch bank {
        case 1:
            bank1.play(noteNumber: note, velocity: 80, frequency: note.midiNoteToFrequency())
        case 2:
            bank2.play(noteNumber: note, velocity: 80, frequency: note.midiNoteToFrequency())
        default:
            ()
        }
    }

    func noteOff(note: MIDINoteNumber, bank: Int) {
        switch bank {
        case 1:
            bank1.stop(noteNumber: note)
        case 2:
            bank2.stop(noteNumber: note)
        default:
            ()
        }
    }
}

// Create your engine and start the player
//let engine = AudioEngine()
//engine.player.play()

