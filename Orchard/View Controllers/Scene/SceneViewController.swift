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
    
    @IBOutlet weak var xCoordinateLabel: NSTextField!
    @IBOutlet weak var yCoordinateLabel: NSTextField!
    @IBOutlet weak var zCoordinateLabel: NSTextField!
    
    lazy var stateObserver = {
        
        return SceneStateObserver(initialState: .empty(editor: nil))
    }()
    
    var keyboardCallbackReference: SceneKitView.Keyboard.CallbackReference?
    
    var graticuleIdentifier: SceneKitView.Graticule.CallbackReference?
}

extension SceneViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension SceneViewController: SceneRendererDelegate {
    
    func update(deltaTime: TimeInterval, frameTime: TimeInterval) {
        
        switch stateObserver.state {
            
        case .editor(let editor):
            
            switch editor.meadow.scene.cameraJib.model.state {
                
            case .orbit(let vector, let edge, var zoom):
                
                let forward = SCNVector3(x: editor.meadow.scene.cameraJib.worldFront.x, y: 0.0, z: editor.meadow.scene.cameraJib.worldFront.z)
                
                var offset = SCNVector3.Zero
                
                switch editor.meadow.input.keyboard.state {
                    
                case .keysHeld(let keys):
                    
                    keys.forEach { key in
                        
                        switch key {
                            
                        case .w:
                            
                            offset += forward
                            
                        case .a:
                            
                            offset += SCNVector3.negate(vector: editor.meadow.scene.cameraJib.worldRight)
                            
                        case .s:
                            
                            offset += SCNVector3.negate(vector: forward)
                            
                        case .d:
                            
                            offset += editor.meadow.scene.cameraJib.worldRight
                            
                        case .z:
                            
                            zoom += -Axis.unitY
                            
                        case .x:
                            
                            zoom += Axis.unitY
                            
                        default: break
                        }
                    }
                    
                    editor.meadow.scene.cameraJib.model.state = .orbit(vector: vector + offset, edge: edge, zoom: zoom)
                    
                default: break
                }
                
            default: break
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
                
                if let reference = self.keyboardCallbackReference {
                    
                    editor.meadow.input.keyboard.unsubscribe(reference)
                }
                
                self.keyboardCallbackReference = nil
                
                if let graticuleIdentifier = self.graticuleIdentifier {
                    
                    editor.meadow.input.graticule.unsubscribe(graticuleIdentifier)
                }
                
                self.graticuleIdentifier = nil
                
            case .editor(let editor):
                
                editor.meadow.input.cursor.tracksIdleEvents = true
                
                if self.graticuleIdentifier == nil {
                    
                    self.graticuleIdentifier = editor.meadow.input.graticule.subscribe(self.stateDidChange(from:to:))
                }
                
                if self.keyboardCallbackReference == nil {
                
                    self.keyboardCallbackReference = editor.meadow.input.keyboard.subscribe(self.stateDidChange(from:to:))
                }
            }
        }
    }
}

extension SceneViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneKitView.GraticuleState?, to: SceneKitView.GraticuleState) {
        
        switch self.stateObserver.state {
            
        case .editor:
            
            switch to {
                
            case .tracking(_, let end, _, _):
                
                self.xCoordinateLabel.integerValue = end.coordinate.x
                self.yCoordinateLabel.integerValue = end.coordinate.y
                self.zCoordinateLabel.integerValue = end.coordinate.z
                
            default: break
            }
            
        default: break
        }
    }
}

extension SceneViewController: KeyboardObserver {
    
    func stateDidChange(from: SceneKitView.KeyboardState?, to: SceneKitView.KeyboardState) {
        
        switch self.stateObserver.state {
            
        case .editor(let editor):
            
            switch editor.meadow.scene.cameraJib.model.state {
                
            case .orbit(let vector, var edge, let zoom):
                
                switch to {
                    
                case .keyDown(let key):
                    
                    switch key {
                        
                    case .q:
                        
                        edge = (GridEdge(rawValue: edge.rawValue + 1) ?? GridEdge.north)
                        
                    case .e:
                        
                        edge = (GridEdge(rawValue: edge.rawValue - 1) ?? GridEdge.west)
                        
                    default: break
                    }
                    
                    editor.meadow.scene.cameraJib.model.state = .orbit(vector: vector, edge: edge, zoom: zoom)
                    
                default: break
                }
                
            default: break
            }
            
        default: break
        }
    }
}
