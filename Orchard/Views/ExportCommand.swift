//
//  ExportCommand.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import SwiftUI

struct ExportCommand: View {
    
    @FocusedBinding(\.document) var document: Document?
    
    var body: some View {
        
        Button(action: {
            
            guard let scene = document?.model.editorModel.harvest else { return }
            
            document?.model.export(scene: scene)
            
        }, label: {
            
            Text("Export")
                .help("Export Map")
        })
            .keyboardShortcut("E")
    }
}
