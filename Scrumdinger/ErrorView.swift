//
//  ErrorView.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/12/27.
//

import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    @Environment(\.dismiss) private var dismiss   /// Create a new property named dismiss. With the @Environment property wrapper, you can read a value that the view’s environment stores, such as the view’s presentation mode, scene phase, visibility, or color scheme. In this case, you access the view’s dismiss structure and call it like a function to dismiss the view.
    
    var body: some View {
        NavigationView {
            VStack {
                Text("An error has occurred!")
                    .font(.title)
                    .padding(.bottom)
                Text(errorWrapper.error.localizedDescription)
                      .font(.headline)
                Text(errorWrapper.guidance)
                    .font(.caption)
                    .padding(.top)
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()   /// dismiss is a structure. You can call a structure like a function if it includes callAsFunction().
                    }
                }
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum SampleError: Error {  /// Create a new SampleError enumeration in the preview structure to represent a sample error property.
        case errorRequired
    }
    
    static var wrapper: ErrorWrapper {
        ErrorWrapper(error: SampleError.errorRequired,
                     guidance: "You can safely ignore this error.")
    }
    
    static var previews: some View {
        ErrorView(errorWrapper: wrapper)
    }
}
