//
//  TimerWidgetBundle.swift
//  TimerWidget
//
//  Created by Raúl Gómez Acuña on 07/01/2024.
//

import WidgetKit
import SwiftUI

@main
struct TimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimerWidgetLiveActivity()
    }
}
	

/*
 * Widget Bundle Entry Point: Main entry point for the widget extension
 * - Registers the Live Activity with the iOS widget system
 * - Required for the widget to be recognized by iOS
 */

// Rest of the file remains the same...
