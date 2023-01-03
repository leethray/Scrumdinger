//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/04/27.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase   /// SwiftUI indicates the current operational state of your app’s Scene instances with a scenePhase Environment value. You’ll observe this value and save user data when it becomes inactive.
    @State private var isPresentingNewScrumView = false  /// The isPresentingNewScrumView property controls the presentation of the edit view to create a new scrum.
    @State private var newScrumData = DailyScrum.Data()  /// Add a @State property named newScrumData with a default value of DailyScrum.Data(). The newScrumData property is the source of truth for all the changes the user makes to the new scrum.
    let saveAction: ()->Void   /// Add a saveAction property and pass an empty action in the preview. You’ll provide the saveAction closure when instantiating ScrumsView.
    
    var body: some View {
        /// The List initializer below accepts a ViewBuilder as its only parameter. So, you can add rows with the same syntax you’ve been using with other container views such as HStack and VStack.
        /// Tip: You can also initialize lists from collections of data, specify a different selection type, and more. To learn about the List view, read the Apple Developer Documentation.
        /// populate the List using a ForEach view. To create views using ForEach, you’ll pass its initializer a collection of items along with a closure that creates a view for each item.
        List {
            ForEach($scrums) { $scrum in   ///Add a ForEach view. Pass the scrums array and a key path to the title property to the initializer.
                /// The ForEach view passes a scrum into its closure, but the DetailView initializer expects a binding to a scrum. You’ll use array binding syntax to retrieve a binding to an individual scrum. To use array binding syntax in SwiftUI, you’ll pass a binding to an array into a ForEach loop.
                /// Modify the ForEach view to accept a Binding<[DailyScrum]>.
                NavigationLink(destination: DetailView(scrum: $scrum)) { /// Add a NavigationLink, The destination presents a single view in the navigation hierarchy when a user interacts with the element.
                    CardView(scrum: scrum)   ///Initialize a CardView in the ForEach closure. This closure returns a CardView for each element in the scrums array.
                    /// LS: because CardView initializer does not expect a binding to a scrum, so simply pass `scrum` to it.
                }
                .listRowBackground(scrum.theme.mainColor) /// Set the background color of the row to scrum.theme.mainColor.
            }
        }
        .navigationTitle("Daily Scrums") /// Add a navigationTitle of "Daily Scrums". Notice that you add the .navigationTitle modifier to the List. The child view can affect the appearance of the NavigationView using modifiers.
        .toolbar {
            Button(action: {
                isPresentingNewScrumView = true
            }){
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        }
        /// SwiftUI automatically adds the Back button in the detail view and fills in the title of the previous screen.
        .sheet(isPresented: $isPresentingNewScrumView) {
            NavigationView {
                DetailEditView(data: $newScrumData)  ///DetailEditView takes a binding to newScrumData, but the @State property in ScrumsView maintains the source of truth.
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                                newScrumData = DailyScrum.Data()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newScrum = DailyScrum(data: newScrumData)
                                scrums.append(newScrum) //Append newScrum to the scrums array. The scrums array is a binding, so updating the array in this view updates the source of truth contained in the app.
                                isPresentingNewScrumView = false
                                newScrumData = DailyScrum.Data()  // Reinitialize newScrumData when the user dismisses the sheet.
                            }
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { phase in  /// You can use onChange(of:perform:) to trigger actions when a specified value changes.
                if phase == .inactive { saveAction() }
        }
    }
}

// embed the ScrumsView preview in a NavigationView.
struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {}) //In ScrumsView_Previews, pass an array of scrums to the ScrumsView initializer.
        }
    }
}
