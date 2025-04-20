//
//  AudioManager.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/20/25.
//

import Foundation
import AVFoundation

enum AudioSounds {
    case bell
    case other
    
    var resource: String {
        switch self {
        case .bell:
            return "bell.mp3"
        case .other:
            return "bell.mp3"
        }
    }
}

class AudioManager {
    private var _audioPlayer: AVAudioPlayer?
    func play(_ sound: AudioSounds) {
        let path = Bundle.main.path(forResource: sound.resource, ofType: nil)!
        let url = URL(filePath: path)
        
        do {
            _audioPlayer = try AVAudioPlayer(contentsOf: url)
            _audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}
