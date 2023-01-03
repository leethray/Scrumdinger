//
//  SpeakerArc.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2023/01/01.
//

import SwiftUI

struct SpeakerArc: Shape {
    let speakerIndex: Int
    let totalSpeakers: Int   /// You’ll base the number of arc segments on the number of total speakers. The speaker index indicates which attendee is speaking and how many segments to draw.

    private var degreesPerSpeaker: Double {
        360.0 / Double(totalSpeakers)   /// Use totalSpeakers to calculate the degrees of a single arc.
    }
    private var startAngle: Angle {
        Angle(degrees: degreesPerSpeaker * Double(speakerIndex) + 1.0)  /// The additional 1.0 degree is for visual separation between arc segments.
    }
    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degreesPerSpeaker - 1.0)
    }
    
    func path(in rect: CGRect) -> Path {  /// The Path initializer takes a closure that passes in a path parameter.
        let diameter = min(rect.size.width, rect.size.height) - 24.0  /// In the path(in:) function, create a constant diameter for the circle of the arc. The path(in:) function takes a CGRect parameter. The coordinate system contains an origin in the lower left corner, with positive values extending up and to the right.
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY) ///The CGRect structure supplies two properties that provide the x- and y-coordinates for the center of the rectangle.
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}
