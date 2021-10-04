//
//  AppView.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import SwiftUI

struct AppView: View {
    
    @ObservedObject var document: Document

    var body: some View {
        
        NavigationView {
            
            SidebarView(model: document.model)
                .frame(minWidth: 210)
                .toolbar {
                    
                    Button(action: toggleSidebar) {
                        
                        Image(systemName: "sidebar.left")
                            .help("Toggle Tileset Sidebar")
                    }
                }
            
            Text("No Selection")
            
            EditorView(model: document.model)
                .frame(minWidth: 210, minHeight: 210)
        }
    }
    
    private func toggleSidebar() {
        
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
