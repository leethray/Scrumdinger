//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/04/27.
//

import Foundation
import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()  /// Declares a @StateObject property named scrumTimer as the source of truth for its view hierarchy. You can use @StateObject to create a source of truth for reference type models that conform to the ObservableObject protocol.
    /// Wrapping a property as a @StateObject means the view owns the source of truth for the object. @StateObject ties the ScrumTimer, which is an ObservableObject, to the MeetingView life cycle.
    @StateObject var speechRecognizer = SpeechRecognizer()   /// The initializer requests access to the speech recognizer and microphone the first time the system calls the object.
    @State private var isRecording = false
    private var player: AVPlayer { AVPlayer.sharedDingPlayer } /// Add a player property that returns AVPlayer.sharedDingPlayer.
    /// The Models > AVPlayer+Ding.swift file in the starter project defines the sharedDingPlayer object, which plays the ding.wav resource.

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            VStack {
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
                MeetingTimerView(speakers: scrumTimer.speakers, isRecording: isRecording, theme: scrum.theme)
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .onAppear {  /// reset and start an timer after a view appears
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            scrumTimer.speakerChangedAction = {
                player.seek(to: .zero) /// In the closure, seek to time .zero in the audio file.
                /// Seeking to time .zero ensures the audio file always plays from the beginning.
                player.play()
            }
            speechRecognizer.reset()   /// Calling reset() ensures that the speech recognizer is ready to begin.
            speechRecognizer.transcribe()
            isRecording = true
            scrumTimer.startScrum()
        }
        .onDisappear {
            scrumTimer.stopScrum()
            speechRecognizer.stopTranscribing()  /// When the meeting timer screen disappears, the stopTranscribing() method stops the transcription.
            isRecording = false
            let newHistory = History(attendees: scrum.attendees, lengthInMinutes: scrum.timer.secondsElapsed / 60, transcript: speechRecognizer.transcript)
            scrum.history.insert(newHistory, at: 0)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
