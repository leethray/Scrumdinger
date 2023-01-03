//
//  DailyScrum.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/04/27.
//

import Foundation

//ForEach structures generate dynamic views by iterating over identifiable data. In the previous section, you used a key path to identify scrums by their titles. This approach worked for prototyping because each scrum in the sample data has a unique title. But users would experience issues if they tried to create a new scrum with the same title as an existing one.
//To work with user-generated content, you’ll make DailyScrum conform to the Identifiable protocol for a more robust way to communicate identity. The protocol has one requirement: an id property that provides a stable identifier for the entity.

struct DailyScrum: Identifiable, Codable {
    let id: UUID  /// To conform to Identifiable, a model must have a property named id. Add a constant named id of type UUID.
    var title: String
    var attendees: [Attendee]
    var lengthInMinutes: Int
    var theme: Theme
    var history: [History] = []
    
    ///   Add an initializer that assigns a default value to the id property. Otherwise DailyScrum initializers in the data array don’t include an id argument.
    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, theme: Theme) {
        self.id = id
        self.title = title
        self.attendees = attendees.map { Attendee(name: $0) }  /// Update the attendees type to [Attendee]. Then, map the attendee names array to the values of the Attendee type in the initializer.
        /// map(_:) creates a new collection by iterating over and applying a transformation to each element in an existing collection.
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
}

extension DailyScrum {  /// In DailyScrum.swift, create an extension with an inner structure named Attendee that is identifiable.
    struct Attendee: Identifiable, Codable {
        let id: UUID
        var name: String
        
        init(id: UUID = UUID(), name: String) {  ///Add an initializer that assigns a default value to the id property.
            self.id = id
            self.name = name
        }
    }
    struct Data {  /// By making Data a nested type, you keep DailyScrum.Data distinct from the Data structure defined in the Foundation framework.
        /// Note: Assign default values to all properties. If all properties have default values, the compiler creates an initializer that takes no arguments. With this initializer, you can create a new instance by calling Data().
        var title: String = ""
        var attendees: [Attendee] = []
        var lengthInMinutes: Double = 5 /// Users adjust a meeting’s length with a Slider view. Because sliders work with Double values, you define lengthInMinutes as a Double.
        var theme: Theme = .seafoam
    }
    
    /// Add a computed `data` property that returns Data with the DailyScrum property values.
    var data: Data {
        /// Remember to cast lengthInMinutes to a Double. All other properties have a matching type.
        Data(title: title, attendees: attendees, lengthInMinutes: Double(lengthInMinutes), theme: theme)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        attendees = data.attendees
        lengthInMinutes = Int(data.lengthInMinutes)
        theme = data.theme
    }
    
    init(data: Data) {
        id = UUID()
        title = data.title
        attendees = data.attendees
        lengthInMinutes = Int(data.lengthInMinutes)
        theme = data.theme
    }
}

extension DailyScrum {
    static let sampleData: [DailyScrum] =  // sample data is an array of DailyScrum structures
    [
        DailyScrum(title: "Design", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 10, theme: .yellow),
        DailyScrum(title: "App Dev", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, theme: .orange),
        DailyScrum(title: "Web Dev", attendees: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sarah"], lengthInMinutes: 5, theme: .poppy)
    ]
}
