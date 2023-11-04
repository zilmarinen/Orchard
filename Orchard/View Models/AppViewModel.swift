//
//  AppViewModel.swift
//
//  Created by Zack Brown on 09/09/2023.
//

import Bivouac
import Euclid
import Foundation
import Harvest
import SceneKit

class AppViewModel: ObservableObject {
    
    internal enum AppState {
        
        internal enum EditorState {
            
            case interior
            case region
            case world
        }
        
        case splash(duration: Double)
        case loading(editorState: EditorState)
        case scene
    }
    
    @Published internal private(set) var state: AppState = .splash(duration: 2.0)
    
    internal let scene = EditorScene()
}

extension AppViewModel {
    
    internal func show(editorState: AppState.EditorState) {
        
        switch editorState {
            
        case .interior: break
        case .region: break
        case .world: self.state = .loading(editorState: editorState)
        }
    }
}
