//
//  MeadowView.swift
//
//  Created by Zack Brown on 01/10/2021.
//

import Harvest
import SceneKit
import SwiftUI

struct MeadowView: View {
    
    let model = MeadowViewModel(map: Map2D())
    
    var body: some View {
        
        switch model.state {
            
        case .idle: Text("Meadow")
            
        case .error(let error):
            
            Text("Error: \(error.localizedDescription)")
            
        case .loading(let map, let progress):
            
            VStack {
            
                Text("Loading \(map.name ?? "")")
                
                ProgressView(progress)
                .progressViewStyle(CircularProgressViewStyle())
            }
            
        case .rendering(let scene):
            
            SceneView(scene: scene)
        }
    }
}
