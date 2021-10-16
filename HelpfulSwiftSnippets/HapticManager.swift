//
//  HapticManager.swift
//  HelpfulSwiftSnippets
//
//  Created by Steven Yu on 10/15/21.
//

import Foundation
import SwiftUI

// A simple Haptic Manager that deals with giving haptic feedback to a user
/*
 Example Usage:
 HapticManager.notification(type: .success)
 */

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
