//
//  AudioEngine.swift
//  ChordVoice
//
//  Created by Jake Smolowe on 2/3/18.
//  Copyright © 2018 Jake Smolowe. All rights reserved.
//

import Foundation
import AudioKit

class MidiBankNote {
    var playCount: Int
    var bank: Int
    var noteNum: MIDINoteNumber
    
    init(bank: Int, noteNum: MIDINoteNumber) {
        self.playCount = 0
        self.bank = bank
        self.noteNum = noteNum
    }
}

// Create a class to handle the audio set up
class AudioEngine {
    
    // Declare your nodes as instance variables
    var bank1 = AKOscillatorBank()
    var bank2 = AKOscillatorBank()
    var mixer = AKMixer()
    var waveform1 = AKTable()
    var waveform2 = AKTable()
    var reverb1 = AKReverb()
    var reverb2 = AKReverb()
    var tremolo1 = AKTremolo()
    var tremolo2 = AKTremolo()
    var bank1Notes = [MidiBankNote]()
    var bank2Notes = [MidiBankNote]()
    
    init(waveform1: AKTable, waveform2: AKTable) {
        self.waveform1 = waveform1
        self.waveform2 = waveform2
        self.bank1 = AKOscillatorBank(waveform: waveform1, attackDuration: 0, decayDuration: 0, sustainLevel: 1.0, releaseDuration: 0, pitchBend: 0.0, vibratoDepth: 0, vibratoRate: 0)
        self.bank1.rampTime = 0.0
        self.bank2 = AKOscillatorBank(waveform: waveform2, attackDuration: 0, decayDuration: 0, sustainLevel: 1.0, releaseDuration: 0, pitchBend: 0.0, vibratoDepth: 0, vibratoRate: 0)
        self.bank2.rampTime = 0.0
        self.bank1Notes = fillMIDIBank(bank: 1)
        self.bank2Notes = fillMIDIBank(bank: 2)
        
        self.tremolo1 = AKTremolo(bank1)
        self.tremolo2 = AKTremolo(bank2)
        self.reverb1 = AKReverb(tremolo1)
        self.reverb2 = AKReverb(tremolo2)

        tremolo1.depth = 0.125
        tremolo2.depth = 0.125
        tremolo1.frequency = 0.25
        tremolo2.frequency = 0.25

        tremolo1.start()
        tremolo2.start()
        reverb1.loadFactoryPreset(.mediumRoom)
        reverb2.loadFactoryPreset(.mediumRoom)
        reverb1.dryWetMix = 0.25
        reverb2.dryWetMix = 0.25
        self.mixer = AKMixer(reverb1, reverb2)
        
        AudioKit.output = mixer
        mixer.volume = 0.5
        
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit failed to start!")
        }
    }
    
    func fillMIDIBank(bank: Int) -> [MidiBankNote] {
        var midiNoteBank = [MidiBankNote]()
        
        var i = 0
        var m: MIDINoteNumber = 0
        while i <= 127 {
            let note = MidiBankNote(bank: bank, noteNum: m)
            midiNoteBank.append(note)
            i += 1
            m += 1
        }
        
        return midiNoteBank
    }
    
    func noteOn(note: MIDINoteNumber, bank: Int) {
        switch bank {
        case 1:
            bank1.play(noteNumber: note, velocity: 80, frequency: note.midiNoteToFrequency())
        case 2:
            bank2.play(noteNumber: note, velocity: 60, frequency: note.midiNoteToFrequency())
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
    
    func ifCountZero(note: MidiBankNote, bank: Int) {
        if note.playCount == 0 {
            noteOff(note: note.noteNum, bank: bank)
        }
    }

}
