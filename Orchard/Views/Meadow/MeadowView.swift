//
//  MeadowView.swift
//
//  Created by Zack Brown on 01/10/2021.
//

import SceneKit
import SwiftUI

struct MeadowView: View {
    
    let model = MeadowViewModel()
    
    var body: some View {
        
        switch model.state {
            
        case .idle: Text("Meadow")
            
        case .error(let error):
            
            Text("Error: \(error.localizedDescription)")
            
        case .loading(let map, let progress):
            
            ProgressView(progress)
            Text("Loading \(map.name ?? "")")
            
        case .rendering(let scene):
            
            SceneView(scene: scene)
        }
    }
}
