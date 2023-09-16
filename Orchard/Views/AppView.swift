//
//  AppView.swift
//
//  Created by Zack Brown on 09/09/2023.
//

import SceneKit
import SwiftUI

struct AppView: View {
    
    @Binding var document: Document
    
    @ObservedObject private var viewModel = AppViewModel()
    
    var body: some View {
        
        SceneView(scene: viewModel.scene,
                  pointOfView: viewModel.scene.camera.pov,
                  options: [.allowsCameraControl,
                            .autoenablesDefaultLighting],
                  delegate: viewModel.scene)
    }
}
