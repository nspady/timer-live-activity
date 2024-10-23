//
//  TimerWidgetLiveActivityIntent.swift
//  FancyTimer
//
//  Created by Raúl Gómez Acuña on 30/01/2024.
//

import Foundation
import AppIntents

/*
 * Intent Definitions: Defines actions that can be triggered from the widget
 * - Declares intents for pause/resume/reset actions
 * - Uses TimerEventEmitter to send events back to React Native
 * - These intents are triggered by button taps in the widget
 */

public struct PauseIntent: LiveActivityIntent {
  public init() {}
  public static var title: LocalizedStringResource = "Pause timer"
  public func perform() async throws -> some IntentResult {
    // Send event to React Native
    TimerEventEmitter.emitter?.sendEvent(withName: "onPause", body: Date().timeIntervalSince1970)
    return .result()
  }
}

public struct ResumeIntent: LiveActivityIntent {
  public init() {}
  public static var title: LocalizedStringResource = "Resume timer"
  public func perform() async throws -> some IntentResult {
    TimerEventEmitter.emitter?.sendEvent(withName: "onResume", body: nil)
    return .result()
  }
}

public struct ResetIntent: LiveActivityIntent {
  public init() {}
  public static var title: LocalizedStringResource = "Reset timer"
  public func perform() async throws -> some IntentResult {
    TimerEventEmitter.emitter?.sendEvent(withName: "onReset", body: nil)
    return .result()
  }
}
