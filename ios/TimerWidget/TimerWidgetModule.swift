/*
 * Bridge Module: Main interface between React Native and iOS Live Activities
 * - Receives commands from React Native to start/stop/pause/resume the timer
 * - Manages the Live Activity lifecycle and state
 * - Called by the React Native JavaScript code through the bridge
 */

import Foundation
import ActivityKit

typealias RCTResponseSenderBlock = ([Any]) -> Void

@objc(TimerWidgetModule)
class TimerWidgetModule: NSObject {
  private var currentActivity: Activity<TimerWidgetAttributes>?
  private var startTime: Date?
  private var elapsedTime: TimeInterval = 0

  private func areActivitiesEnabled() -> Bool {
    return ActivityAuthorizationInfo().areActivitiesEnabled
  }
  
  private func resetValues() {
    startTime = nil
    elapsedTime = 0
    currentActivity = nil
  }

  @objc
  func startLiveActivity(_ timestamp: Double) -> Void {
    startTime = Date(timeIntervalSince1970: timestamp)
    if (!areActivitiesEnabled()) {
      // User disabled Live Activities for the app, nothing to do
      return
    }
    // Preparing data for the Live Activity
    let activityAttributes = TimerWidgetAttributes()
    let contentState = TimerWidgetAttributes.ContentState(startTime: startTime!, elapsedTime: 0, isRunning: true)
    let activityContent = ActivityContent(state: contentState, staleDate: nil)
    do {
      // Request to start a new Live Activity with the content defined above
      currentActivity = try Activity.request(attributes: activityAttributes, content: activityContent)
    } catch {
      // Handle errors, skipped for simplicity
    }
  }

  @objc
  func stopLiveActivity() -> Void {
    resetValues()
    Task {
      for activity in Activity<TimerWidgetAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
    }
  }
  
  @objc
  func pause(_ timestamp: Double, elapsedTime: Double) {
    Task {
      if let activity = currentActivity {
        await activity.update(
          ActivityContent(
            state: TimerWidgetAttributes.ContentState(
              startTime: Date(timeIntervalSince1970: timestamp),
              elapsedTime: elapsedTime,
              isRunning: false
            ),
            staleDate: nil
          )
        )
      }
    }
  }
  
  @objc
  func resume() -> Void {
    startTime = Date()
    let contentState = TimerWidgetAttributes.ContentState(startTime: startTime!, elapsedTime: elapsedTime, isRunning: true)
    Task {
      await currentActivity?.update(
        ActivityContent<TimerWidgetAttributes.ContentState>(
          state: contentState,
          staleDate: nil
        )
      )
    }
  }

  @objc
  func getCurrentState(_ callback: @escaping ([Any]) -> Void) -> Void {
    Task { @MainActor in
      if let activity = await Activity<TimerWidgetAttributes>.activities.first {
        let state: [String: Any] = [
          "isRunning": activity.content.state.isRunning,
          "elapsedTime": activity.content.state.elapsedTime,
          "startTime": activity.content.state.startTime.timeIntervalSince1970
        ]
        callback([state])
      } else {
        callback([[:]])
      }
    }
  }
}
