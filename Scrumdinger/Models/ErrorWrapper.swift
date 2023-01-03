//
//  ErrorWrapper.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/12/27.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error  /// an error property that conforms to the Error protocol. You can use the Error protocol to explicitly assign a type to an error-handling property.
    let guidance: String  /// Scrumdinger displays the guidance string when the associated error occurs.

    init(id: UUID = UUID(), error: Error, guidance: String) {  /// an initializer that accepts an error and a guidance string and that assigns a default value for id.

        self.id = id
        self.error = error
        self.guidance = guidance
    }
}
