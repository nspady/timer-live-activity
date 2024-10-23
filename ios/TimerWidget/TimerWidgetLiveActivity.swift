//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Raúl Gómez Acuña on 07/01/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents


struct TimerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var startTime: Date
        var elapsedTime: TimeInterval
        var isRunning: Bool
    }
}

struct TimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
            TimerWidgetView(state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    TimerDisplay(state: context.state)
                }
            } compactLeading: {
                Image(systemName: "timer")
            } compactTrailing: {
                TimerDisplay(state: context.state)
            } minimal: {
                Image(systemName: "timer")
            }
        }
    }
}

struct TimerWidgetView: View {
    let state: TimerWidgetAttributes.ContentState
    
    var body: some View {
        VStack {
            TimerDisplay(state: state)
                .font(.largeTitle)
                .foregroundColor(.cyan)
                .monospacedDigit()
            
            HStack {
                if state.isRunning {
                    Button(intent: PauseIntent()) {
                        Image(systemName: "pause.fill")
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button(intent: ResumeIntent()) {
                        Image(systemName: "play.fill")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Button(intent: ResetIntent()) {
                    Image(systemName: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

struct TimerDisplay: View {
    let state: TimerWidgetAttributes.ContentState
    
    var body: some View {
        if state.isRunning {
            Text(state.startTime, style: .timer)
        } else {
            Text(timerText)
                .monospacedDigit()
        }
    }
    
    private var timerText: String {
        let totalSeconds = Int(state.elapsedTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
// Preview
struct TimerWidgetLiveActivity_Previews: PreviewProvider {
    static var previews: some View {
        TimerWidgetView(state: TimerWidgetAttributes.ContentState(startTime: Date(), elapsedTime: 65, isRunning: true))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
