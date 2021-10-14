//
//  XMarkButton.swift
//  HelpfulSwiftSnippets
//
//  Created by Steven Yu on 10/14/21.
//

import SwiftUI

// An x button component that allows the user to exit out of a sheet
/*
 You can use this x button to exit out of a sheet.
 You should probably place this in a toolbar.
 
 Example Usage:
 NavigationView {
    Text("Hello, world!")
        .toolbar(content: {
             ToolbarItem(placement: .navigationBarLeading) {
                 XMarkButton()
             }
        }
 }
 */

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundColor(.red)
        })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
