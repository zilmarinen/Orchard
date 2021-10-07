//
//  EditorView.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import SceneKit
import SpriteKit
import SwiftUI

struct EditorView: View {
    
    @ObservedObject var appModel: AppViewModel
    
    var body: some View {
        
        switch appModel.editorModel.state {
            
        case .idle: Text("Orchard")
            
        case .error(let error):
            
            Text("Error: \(error.localizedDescription)")
            
        case .loading(let map, let progress):
            
            VStack {
            
                Text("Loading \(map.name ?? "")")
                
                ProgressView(progress)
                .progressViewStyle(CircularProgressViewStyle())
            }
            
        case .rendering(let scene):
            
            SpriteView(scene: scene)
                .toolbar {
                    
                    Button {
                        
                        appModel.preview(scene: scene)
                        
                    } label: {
                        
                        Image(systemName: "sidebar.right")
                            .help("Preview Scene")
                    }
                }
        }
    }
}
