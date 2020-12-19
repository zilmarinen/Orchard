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
    
    let blueprint = SCNNode()
    let focus = SCNNode()
    
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
              let sceneView = sceneView,
              let device = sceneView.device else { fatalError("Invalid start option") }
        
        scene.meadow.library = try? device.makeDefaultLibrary(bundle: Meadow.bundle)
        scene.rootNode.addChildNode(blueprint)
        scene.rootNode.addChildNode(focus)
        
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.play(nil)
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = true
        
        scene.camera.controller.focus(node: focus, ordinal: .northEast, zoom: 1.0)
        
        focus(node: scene)
        
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
            
            var vector = Vector.zero
            
            for key in keys {
                
                switch key {
                
                case .w: vector += Ordinal.southEast.vector
                case .a: vector += Ordinal.northEast.vector
                case .s: vector += Ordinal.northWest.vector
                case .d: vector += Ordinal.southWest.vector
                default: break
                }
            }
            
            let v0 = Vector(vector: focus.position)
            
            focus.position = SCNVector3(vector: (v0 + vector))
            
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
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .keyUp(let key):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene else { return }
                
                switch key {
                
                case .q:
                    
                    scene.camera.controller.rotate(direction: .anticlockwise)
                    
                case .e:
                    
                    scene.camera.controller.rotate(direction: .clockwise)
                    
                default: break
                }
                
            default: break
            }
        }
    }
}

extension SceneCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .zoom(_, let delta):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene else { return }
                
                let direction: Camera.CameraController.Transform.Zoom = (delta > 0 ? .in(-delta) : .out(abs(delta)))
                
                scene.camera.controller.zoom(direction: direction)
                
            default: break
            }
        }
    }
}
