//
//  SceneCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow
import SceneKit

class SceneCoordinator: Coordinator<SceneViewController>, KeyboardObservable, MouseObservable {
    
    var keyboardObserver: UUID?
    var mouseObserver: UUID?
    
    override init(controller: SceneViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        guard let scene = option as? Scene,
              let sceneView = sceneView else { fatalError("Invalid start option") }
        
        sceneView.backgroundColor = scene.backgroundColor.color
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.play(nil)
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        
        focus(node: scene)
        
        scene.camera.camera?.usesOrthographicProjection = true
        scene.camera.position = SCNVector3(x: 20, y: 20, z: 20)
        scene.camera.look(at: SCNVector3(x: 0, y: 0, z: 0))
        
        subscribeToKeyboardEvents()
        subscribeToMouseEvents()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromKeyboardEvents()
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
}

extension SceneCoordinator: SCNSceneRendererDelegate {

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard let sceneView = sceneView,
              let scene = sceneView.scene as? Scene else { return }
        
        scene.renderer(renderer, updateAtTime: time)
        
        switch sceneView.keyboardObserver.state {
        
        case .keysHeld(let keys):
            
            print("keys are held down: [\(keys)]")
            
        default: break
        }
    }
}

extension SceneCoordinator {
    
    override func focus(node: SceneGraphNode) {
        
        var items: [NSPathControlItem] = []
        
        if let node = node as? (SceneGraphNode & Soilable) {
            
            var parent: (SceneGraphNode & Soilable)? = node
            
            while parent != nil {
                
                let item = NSPathControlItem()
                
                item.title = parent?.name ?? "Meadow"
                item.image = parent?.image
                
                items.append(item)
                
                parent = parent?.ancestor as? (SceneGraphNode & Soilable)
            }
        }
        
        guard let scene = sceneView?.scene as? Scene else { return }
        
        let item = NSPathControlItem()
        
        item.title = scene.name ?? "Scene"
        item.image = NSImage(named: "scene_icon")
        
        items.append(item)
        
        controller.pathControl.pathItems = items.reversed()
    }
}

extension SceneCoordinator {
    
    func stateDidChange(from previousState: SceneView.KeyboardState?, to currentState: SceneView.KeyboardState) {
        
        DispatchQueue.main.async {
            
            switch currentState {
            
            case .keyUp(let key):
                
                print("keyUp -> [\(key)]")
                
            default: break
            }
        }
    }
}

extension SceneCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async {
            
            switch currentState {
            
            case .zoom(let position, let delta):
                
                print("mouseZoom -> [\(position)] - [\(delta)]")
                
            default: break
            }
        }
    }
}
