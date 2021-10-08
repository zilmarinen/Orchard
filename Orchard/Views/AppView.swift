//
//  AppView.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import SwiftUI

struct AppView: View {
    
    enum Constants {
        
        static let sidebarWidth = 210.0
        static let toolWidth = 280.0
        static let editorWidth = 350.0
    }
    
    @ObservedObject var document: Document

    var body: some View {
        
        NavigationView {
            
            SidebarView(appModel: document.model)
                .frame(minWidth: Constants.sidebarWidth)
                .toolbar {
                    
                    Button(action: toggleSidebar) {
                        
                        Image(systemName: "sidebar.left")
                            .help("Toggle Tileset Sidebar")
                    }
                }
            
            Text("No Selection")
            
            EditorView(appModel: document.model)
                .frame(idealWidth: Constants.editorWidth, idealHeight: Constants.editorWidth)
        }
    }
    
    private func toggleSidebar() {
        
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
