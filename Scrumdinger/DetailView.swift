//
//  DetailView.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/04/27.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @Binding var scrum: DailyScrum  // Using a binding ensures that DetailView renders again when the user’s interaction modifies scrum.
    
    @State private var data = DailyScrum.Data()
    @State private var isPresentingEditView = false

    var body: some View {
        List { // use the list to display subviews in a single column with rows.
            Section(header: Text("Meeting Info")) { // Add a Section with the header Meeting Info.
                NavigationLink(destination: MeetingView(scrum: $scrum)) {
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(scrum.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine) // Add accessibilityElement(children:) to the HStack to combine the Label and Text elements for accessibility users. VoiceOver then reads the two elements as one statement, for example, “Length, 10 minutes.” Without the modifier, VoiceOver users have to swipe again between each element.
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(scrum.theme.name)
                         .padding(4)
                         .foregroundColor(scrum.theme.accentColor)
                         .background(scrum.theme.mainColor)
                         .cornerRadius(4)
                }
                .accessibilityElement(children: .combine)
            }
            Section(header: Text("Attendees")) {  // create a Section with a header of "Attendees" to group the attendee information.
                ForEach(scrum.attendees) { attendee in  // Add a ForEach to dynamically generate the list of attendees, and pass scrum.attendees as the data.
                    Label(attendee.name, systemImage: "person")
                }
            }
            Section(header: Text("History")) {
                if scrum.history.isEmpty {
                    Label("No meetings yet", systemImage: "calendar.badge.exclamationmark")
                }
                ForEach(scrum.history) { history in
                    NavigationLink(destination: HistoryView(history: history)) {
                        HStack {
                            Image(systemName: "calendar")
                            Text(history.date, style: .date)
                        }
                    }
                }
            }
        }
        .navigationTitle(scrum.title)  // Display the scrum title by setting .navigationTitle(scrum.title) on the List.
        .toolbar {
            Button("Edit") {
                isPresentingEditView = true // Add a toolbar button that sets isPresentingEditView to true.
                data = scrum.data
            }
        }
        .sheet(isPresented: $isPresentingEditView) { // Add a sheet modifier on List.
            // When isPresentingEditView changes to true, the app presents DetailEditView using a modal sheet that partially covers the underlying content.
            // Modal views remove users from the main navigation flow of the app. Use modality for short, self-contained tasks. For more information about the different types of modal presentation and when to use modality effectively in your apps, see Modality in the Human Interface Guidelines.
            NavigationView {
                DetailEditView(data: $data)  // Update the DetailEditView initializer to include a binding to data.
                // Changes that a user makes to data in the edit view are shared with the data property in the detail view.
                    .navigationTitle(scrum.title) //Set the navigation title of the edit view to `scrum.title`.
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false // Dismiss DetailEditView in the Done button action.
                                scrum.update(from: data)  // At the bottom of the file, call scrum.update(from: data) in the Done button’s closure.
                            }
                        }
                    }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Wrap DetailView in a NavigationView to preview navigation elements on the canvas.
            DetailView(scrum: .constant(DailyScrum.sampleData[0])) // In the preview provider, initialize DetailView with the scrum data.
        }
    }
}
