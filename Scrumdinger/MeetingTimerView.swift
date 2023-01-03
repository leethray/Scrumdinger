//
//  MeetingTimerView.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2023/01/01.
//

import SwiftUI

struct MeetingTimerView: View {
    let speakers: [ScrumTimer.Speaker]
    let isRecording: Bool
    let theme: Theme
    
    private var currentSpeaker: String {
        speakers.first(where: { !$0.isCompleted })?.name ?? "Someone"  /// The current speaker is the first person on the list who hasn’t spoken. If there isn’t a current speaker, the expression returns “Someone.”
    }
    
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: 24)
            .overlay {       /// Overlay a text view on the circle.  Adding text to a layer in front of the circle makes the text appear inside the circle.
                VStack {
                    Text(currentSpeaker)
                        .font(.title)
                    Text("is speaking")
                    Image(systemName: isRecording ? "mic" : "mic.slash")   /// Adding this image enhances the user experience by informing users when the device is actively recording.
                        .font(.title)
                        .padding(.top)
                        .accessibilityLabel(isRecording ? "with transcription" : "without transcription")
                }
                .accessibilityElement(children: .combine)  /// Use the accessibilityElement modifier to combine the elements inside the VStack. This modifier makes VoiceOver read the two text views as one sentence.
                .foregroundStyle(theme.accentColor)
            }
            .overlay  {
                ForEach(speakers) { speaker in
                    if speaker.isCompleted, let index = speakers.firstIndex(where: { $0.id == speaker.id }) {
                        SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
                            .rotation(Angle(degrees: -90))
                            .stroke(theme.mainColor, lineWidth: 12)
                    }
                }
            }
            .padding(.horizontal)
    }
}

struct MeetingTimerView_Preview: PreviewProvider {
    static var speakers: [ScrumTimer.Speaker] {
        [ScrumTimer.Speaker(name: "Bill", isCompleted: true), ScrumTimer.Speaker(name: "Cathy", isCompleted: false)]
    }
    
    static var previews: some View {
        MeetingTimerView(speakers: speakers, isRecording: true, theme: .yellow)
    }
}
