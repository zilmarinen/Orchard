//
//  SceneViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class SceneViewController: NSViewController {

    @IBOutlet weak var sceneView: SceneKitView!
    
    lazy var viewModel = {
        
        return SceneViewModel(initialState: .empty(editor: nil))
    }()
    
    var keyboardCallbackReference: SceneKitView.Keyboard.CallbackReference?
}

extension SceneViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension SceneViewController: SceneRendererDelegate {
    
    func update(deltaTime: TimeInterval, frameTime: TimeInterval) {
        
        switch viewModel.state {
            
        case .editor(let editor):
            
            switch editor.meadow.scene.cameraJib.model.state {
                
            case .focus(let vector, let edge, var zoom):
                
                switch editor.meadow.input.keyboard.state {
                    
                case .keysHeld(let keys):
                    
                    var offset = SCNVector3Zero
                    
                    keys.forEach { key in
                        
                        switch key {
                            
                        case .w:
                            
                            offset += editor.meadow.scene.cameraJib.worldFront
                            
                        case .a:
                            
                            offset += SCNVector3.negate(vector: editor.meadow.scene.cameraJib.worldRight)
                            
                        case .s:
                            
                            offset += SCNVector3.negate(vector: editor.meadow.scene.cameraJib.worldFront)
                            
                        case .d:
                            
                            offset += editor.meadow.scene.cameraJib.worldRight
                            
                        case .z:
                            
                            zoom += -Axis.unitY
                            
                        case .x:
                            
                            zoom += Axis.unitY
                            
                        default: break
                        }
                    }
                    
                    offset = SCNVector3(x: offset.x * MDWFloat(deltaTime * 2.0), y: 0.0, z: offset.z * MDWFloat(deltaTime * 2.0))
                    
                    editor.meadow.scene.cameraJib.model.state = .focus(vector: vector + offset, edge: edge, zoom: zoom)
                    
                default: break
                }
            }
            
        default: break
        }
    }
}

extension SceneViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .empty(let editor):
                
                guard let editor = editor else { break }
                
                editor.meadow.delegate = nil
                
                if let reference = self.keyboardCallbackReference {
                    
                    editor.meadow.input.keyboard.unsubscribe(reference)
                }
                
            case .editor(let editor):
                
                editor.meadow.delegate = self
                
                if self.keyboardCallbackReference == nil {
                
                    self.keyboardCallbackReference = editor.meadow.input.keyboard.subscribe(self.stateDidChange(from:to:))
                }
            }
        }
    }
}

extension SceneViewController: KeyboardObserver {
    
    func stateDidChange(from: SceneKitView.KeyboardState?, to: SceneKitView.KeyboardState) {
        
        switch self.viewModel.state {
            
        case .editor(let editor):
            
            switch editor.meadow.scene.cameraJib.model.state {
                
            case .focus(let vector, var edge, let zoom):
                
                switch to {
                    
                case .keyDown(let key):
                    
                    switch key {
                        
                    case .q: edge = (GridEdge(rawValue: edge.rawValue + 1) ?? GridEdge.north)
                    case .e: edge = (GridEdge(rawValue: edge.rawValue - 1) ?? GridEdge.west)
                        
                    default: break
                    }
                    
                    editor.meadow.scene.cameraJib.model.state = .focus(vector: vector, edge: edge, zoom: zoom)
                    
                default: break
                }
            }
        default: break
        }
    }
}
