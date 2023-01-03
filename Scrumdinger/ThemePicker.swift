//
//  ThemePicker.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/08/04.
//

import SwiftUI

struct ThemePicker: View {
    // Try to maintain a single source of truth for every piece of data in your app. Instead of creating a new source of truth for the theme picker, you’ll use a binding that references a theme structure defined in the parent view.
    @Binding var selection: Theme
    // Create a binding to a theme named selection.
    // This binding communicates changes to the theme within the theme picker, back to the parent view.
    
    var body: some View {
        // Add a picker with the title “Theme” and pass the selection binding.
        // The picker will display all available themes. You’ll make Theme conform to CaseIterable so that you can easily access all the enumeration’s cases.
        Picker("Theme", selection: $selection) {
            ForEach(Theme.allCases) { theme in // add a ForEach to list all cases of Theme.
                ThemeView(theme: theme)
                    .tag(theme) // You can tag subviews when you need to differentiate among them in controls like pickers and lists. Tag values can be any hashable type like in an enumeration.
            }
        }
    }
}

struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        // Pass a constant binding to initialize a theme picker in the preview.
        ThemePicker(selection: .constant(.periwinkle))
    }
}
