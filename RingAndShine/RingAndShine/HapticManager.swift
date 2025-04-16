//
//  HapticManager.swift
//  RingAndShine
//
//  Created by Nayeli Castro on 4/15/25.
//

import Foundation
import SwiftUI
import CoreHaptics

struct HapticManager {
    static func triggerSuccessHaptic(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func triggerSelectionHaptic(){
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
    }
}
