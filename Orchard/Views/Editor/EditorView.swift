//
//  EditorView.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import SceneKit
import SpriteKit
import SwiftUI

struct EditorView: View {
    
    @ObservedObject var model: AppViewModel
    
    var body: some View {
        
        ZStack {
            
            SpriteView(scene: model.harvest)
                .ignoresSafeArea()
            
            Text(model.selectedTool?.id ?? "No selection")
                .foregroundColor(Color.black)
        }
        .toolbar {
            
            Button(action: model.preview) {
                
                Image(systemName: "sidebar.right")
                    .help("Preview Scene")
            }
        }
    }
}
