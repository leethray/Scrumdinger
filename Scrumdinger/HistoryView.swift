//
//  HistoryView.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2023/01/03.
//


import SwiftUI

struct HistoryView: View {
    let history: History

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("Attendees")
                    .font(.headline)
                Text(history.attendeeString)
                if let transcript = history.transcript {
                    Text("Transcript")
                        .font(.headline)
                        .padding(.top)
                    Text(transcript)
                }
            }
        }
        .navigationTitle(Text(history.date, style: .date))
        .padding()
    }
}

extension History {
    var attendeeString: String {
        ListFormatter.localizedString(byJoining: attendees.map { $0.name })
        /// Add a History extension with a list formatter to display attendees in a human-readable string. Then add a text view, and pass in the meeting attendees.
        /// ListFormatter converts the attendees data into a single, comma-separated string.
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var history: History {
        History(attendees: [DailyScrum.Attendee(name: "Jon"), DailyScrum.Attendee(name: "Darla"), DailyScrum.Attendee(name: "Luis")], lengthInMinutes: 10, transcript: "Darla, would you like to start today? Sure, yesterday I reviewed Luis' PR and met with the design team to finalize the UI...")
    }
    
    static var previews: some View {
        HistoryView(history: history)
    }
}
