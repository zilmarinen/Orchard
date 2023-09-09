//
//  ContentView.swift
//  Orchard
//
//  Created by Zack Brown on 09/09/2023.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: OrchardDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(OrchardDocument()))
    }
}
