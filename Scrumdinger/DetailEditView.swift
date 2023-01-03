//
//  DetailEditView.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/08/02.
//

// Create the edit view and add controls for modifying the title and length of the scrum.
// Store changes to the scrum in a Data property. You’ll define the property using the @State wrapper because you need to mutate the property from within the view.
// SwiftUI observes @State properties and automatically redraws the view’s body when the property changes. This behavior ensures the UI stays up to date as the user manipulates the onscreen controls.
                                                                    
import SwiftUI

struct DetailEditView: View {
    @Binding var data: DailyScrum.Data  // data is now an initialization parameter, so you need to remove the private attribute and DailyScrum.Data initialization.
    @State private var newAttendeeName = ""
    // Declare @State properties as private so they can be accessed only within the view in which you define them.
    // The newAttendeeName property will hold the attendee name that the user enters.
    
    var body: some View {
        Form { // The Form container automatically adapts the appearance of controls when it renders on different platforms.
            Section(header: Text("Meeting Info")) {
                TextField("Title", text: $data.title)
                HStack {
                    Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {  // A Slider stores a Double from a continuous range that you specify. Passing a step value of 1 limits the user to choosing whole numbers.
                        Text("Length")  // The Text view won’t appear on screen, but VoiceOver uses it to identify the purpose of the slider.
                    }
                    .accessibilityValue("\(Int(data.lengthInMinutes)) minutes")
                    Spacer()
                    Text("\(Int(data.lengthInMinutes)) minutes")
                        .accessibilityHidden(true) // Hide the text view from VoiceOver. All the information that VoiceOver needs is in the accessibility value for the slider.
                }
                ThemePicker(selection: $data.theme) // create a source of truth for the binding that you added to ThemePicker.swift
            }
            Section(header: Text("Attendees")) {
                ForEach(data.attendees) { attendee in
                    Text(attendee.name)
                }
                .onDelete { indices in  // Add an onDelete modifier to remove attendees from the scrum data.
                    // The framework calls the closure you pass to onDelete when the user swipes to delete a row.
                    data.attendees.remove(atOffsets: indices)
                }
                HStack {
                    TextField("New Attendee", text: $newAttendeeName)
                    // pass a binding to the newAttendeeName property.
                    // The binding keeps newAttendeeName in sync with the contents of the text field. It doesn’t affect the original DailyScrum model data.
                    Button(action: {
                        withAnimation { // Add an animation block that creates a new attendee and appends the new attendee to the attendees array.
                            let attendee = DailyScrum.Attendee(name: newAttendeeName)
                            data.attendees.append(attendee)
                            newAttendeeName = "" // Set newAttendeeName to an empty string inside the animation block.
                            // Because the text field has a binding to newAttendeeName, setting the value to the empty string also clears the contents of the text field.
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel("Add attendee")
                    }
                    .disabled(newAttendeeName.isEmpty) // Disable the button if newAttendeeName is empty.
                }
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(DailyScrum.sampleData[0].data))  // pass a constant binding to the DetailEditView initializer in DetailEditView_Previews.
    }
}
