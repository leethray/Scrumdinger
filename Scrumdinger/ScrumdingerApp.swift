//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/04/27.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    /// Load data on app launch
    /// The @StateObject property wrapper creates a single instance of an observable object for each instance of the structure that declares it.
    @StateObject private var store = ScrumStore()
    @State private var errorWrapper: ErrorWrapper?  /// add an optional state variable named errorWrapper. The default value of an optional is nil. When you assign a value to this state variable, SwiftUI updates the view.
    
    /// Within ScrumdingerApp, in the body of the structure, you add one or more scenes that conform to the Scene protocol. Scenes are containers for a view hierarchy that your app presents. You might design your app to display one scene in iOS and watchOS, for example, but multiple scenes in macOS and iPadOS.
    var body: some Scene {
        ///   WindowGroup is one of the primitive scenes that SwiftUI provides. In iOS, the views you add to the WindowGroup scene builder are presented in a window that fills the device’s entire screen.
        WindowGroup {
            NavigationView { ///  Now you’ll make ScrumsView the app’s root view. You create a SwiftUI app by declaring a structure that conforms to the App protocol. The app’s body property returns a Scene that contains a view hierarchy representing the primary user interface for the app.ak
                ScrumsView(scrums: $store.scrums){
                    Task {
                        do {
                            try await ScrumStore.save(scrums: store.scrums)
                        } catch {
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                        }
                    }
                }
            }
            /// load the user’s scrums when the app’s root NavigationView appears on screen.
            /// SwiftUI provides a task modifier that you can use to associate an async task with a view. You’ll use the modifier to load scrums when the system creates the navigation view.
            .task {
                do {
                    store.scrums = try await ScrumStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {   /// Add a sheet with a binding to the error wrapper item. The modal sheet provides a closure to execute code when the user dismisses the modal sheet, and a closure to supply a view to present modally.
                store.scrums = DailyScrum.sampleData   /// An error occurred when accessing the app’s data. As a fix, you’ll supply some sample data when the user dismisses the error view. In the onDismiss closure, assign sample data to the scrums array. Load sample data when the user dismisses the modal.
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
        }
    }
}


/// Source of Truth
/// Maintaining multiple copies of information can introduce inconsistencies that lead to bugs in your app. To avoid data inconsistency bugs, use a single source of truth for each data element in your app. Store the element in one location — the source of truth — and any number of views can access that same piece of data.
/// You can create sources of truth throughout your code. How and where you define each source of truth depends on whether the data is shared among multiple views and whether the data changes.
/// In Scrumdinger, you’ll establish a source of truth in ScrumdingerApp, which other views will share access to.
/// SwiftUI uses the @State and @Binding property wrappers, among others, to help you maintain a single source of truth for your data.
/// declare state properties as private and avoid using them for persistent storage.

/// When a @State property value changes, the system redraws the view using the updated values of the property. For example, when a user modifies a scrum in Scrumdinger, ScrumsView redraws the list to show the updated values. Because state properties help manage transient states, like the highlight state of a button, filter settings, or a currently selected list item, declare state properties as private and avoid using them for persistent storage.
/// The @State property wrapper is SwiftUI syntax for defining a mutable source of truth that’s local to your view structure. But what if you want to use the same source of truth in another view in the view hierarchy?

