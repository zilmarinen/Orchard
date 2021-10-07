//
//  MeadowView.swift
//
//  Created by Zack Brown on 01/10/2021.
//

import Harvest
import SceneKit
import SwiftUI

struct MeadowView: View {
    
    @ObservedObject var model: MeadowViewModel
    
    var body: some View {
        
        ZStack {
        
            switch model.state {
                
            case .idle:
                
                Text("Meadow")
                
            case .error(let error):
                
                Text("Error: \(error.localizedDescription)")
                
            case .loading(let map, let progress):
                
                VStack {
                
                    Text("Loading \(map.name ?? "")")
                    
                    ProgressView(progress)
                    .progressViewStyle(CircularProgressViewStyle())
                }
                
            case .rendering(let scene):
                
                SceneView(scene: scene,
                          pointOfView: scene.camera.jig,
                          options: .allowsCameraControl,
                          delegate: scene)
            }
        }
        .onOpenURL { url in
            
            guard url.scheme == "orchard",
                  let map = Container.shared.scene?.map else { return }
            
            model.load(map: map)
        }
    }
}
