//
//  AppView.swift
//
//  Created by Zack Brown on 09/09/2023.
//

import SceneKit
import SwiftUI

struct AppView: View {
    
    internal enum Constant {
            
        static let minFrameDimensions = 350.0
    }
    
    @Binding internal var document: Document
    
    @ObservedObject internal var viewModel: AppViewModel
    
    var body: some View {
            
        VStack {
            
            switch viewModel.state {
                
            case .splash: splash
            case .loading: loading
            case .scene: scene
            }
        }
        .frame(minWidth: Constant.minFrameDimensions,
               minHeight: Constant.minFrameDimensions)
    }
    
    internal var splash: some View {
            
        SplashView()
        .onAppear {
            
            guard case let .splash(duration) = viewModel.state else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                
                withAnimation {
                    
                    viewModel.show(editorState: .world)
                }
            }
        }
    }
    
    internal var loading: some View {
            
        VStack {
            
            Text("Loading Scene")
            
            ProgressView()
        }
    }
    
    internal var scene: some View {
        
        NavigationView {
            
            Text("No Selection")
            
            SceneView(scene: viewModel.scene,
                      pointOfView: viewModel.scene.camera.pov,
                      options: [.allowsCameraControl,
                                .autoenablesDefaultLighting],
                      delegate: viewModel.scene)
        }
    }
}
