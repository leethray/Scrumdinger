//
//  ThemeView.swift
//  Scrumdinger
//
//  Created by Sirui.Li on 2022/08/04.
//

import SwiftUI

// You might define a list cell in the same file as the list view structure. By defining the cell in a separate file, you can more easily reuse it in a future project.

struct ThemeView: View {  // The model for this view is a single instance of Theme.
    let theme: Theme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(theme.mainColor)
            Label(theme.name, systemImage: "paintpalette")
                .padding(4)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true) // Set the foreground color of the ZStack to the theme’s accent color and match its vertical size to the intrinsic size of the label.
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: .buttercup)
    }
}
