//
//  MeetingFooterView.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/08/14.
//


import SwiftUI

struct MeetingFooterView: View {
    let speakers: [ScrumTimer.Speaker]
    var skipAction: ()->Void  /// Add a skipAction closure property to the view and pass an empty closure to the MeetingFooterView initializer in the preview.
    private var speakerNumber: Int? { /// ScrumTimer marks each speaker as completed when their time has ended. The first speaker not marked as completed becomes the active speaker. The speakerNumber property uses the index to return the active speaker number, which you’ll use as part of the footer text.
        guard let index = speakers.firstIndex(where: { !$0.isCompleted }) else { return nil}
        return index + 1
    }
    private var isLastSpeaker: Bool {
        return speakers.dropLast().allSatisfy { $0.isCompleted }
    }
    /**
     This property is true if the isCompleted property of each speaker except the last speaker is true.
     Tip:
     You can get the same result with `reduce(_:_:)` by returning `speakers.dropLast().reduce(true) { $0 && $1.isCompleted }`.
     */
    private var speakerText: String {
        guard let speakerNumber = speakerNumber else { return "No more speakers" }
        return "Speaker \(speakerNumber) of \(speakers.count)"
    }
    var body: some View {
        VStack {
            HStack {
                if isLastSpeaker {
                    Text("Last Speaker")
                } else {
                    Text(speakerText)
                    Spacer()
                    Button(action: skipAction) {
                        Image(systemName:"forward.fill")
                    }
                    .accessibilityLabel("Next speaker")
                }
            }
        }
        .padding([.bottom, .horizontal])
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingFooterView(speakers: DailyScrum.sampleData[0].attendees.speakers, skipAction: {})
            .previewLayout(.sizeThatFits)
    }
}
