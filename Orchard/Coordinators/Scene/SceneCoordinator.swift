//
//  SceneCoordinator.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow
import SpriteKit

class SceneCoordinator: Coordinator<SceneViewController> {
    
    lazy var viewModel: SceneViewModel = {
        
        return SceneViewModel(initialState: .editor)
    }()
    
    var stateObserver: UUID?
    
    override init(controller: SceneViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        stateObserver = viewModel.subscribe(stateDidChange(from:to:))
        
        guard let spriteView = spriteView,
              let sceneView = sceneView,
              let device = sceneView.device else { fatalError("Invalid start option") }
        
        sceneView.library = try? device.makeDefaultLibrary(bundle: Meadow.bundle)
        
        if let scene = option as? Map {
            
            scene.isPaused = false
            scene.backgroundColor = .white
            scene.anchorPoint = .init(x: 0.5, y: 0.5)
            scene.scaleMode = .aspectFill
            
            spriteView.presentScene(scene)
        }
        
        if spriteView.scene == nil {
        
            let scene = Map()
        
            scene.isPaused = false
            scene.backgroundColor = .white
            scene.anchorPoint = .init(x: 0.5, y: 0.5)
            scene.scaleMode = .aspectFill
        
            spriteView.presentScene(scene)
            
            _ = scene.meadow.surface.add(tile: .zero)
            _ = scene.meadow.surface.add(tile: Coordinate(x: 1, y: 0, z: 0))
            _ = scene.meadow.surface.add(tile: Coordinate(x: -1, y: 0, z: 0))
            _ = scene.meadow.surface.add(tile: Coordinate(x: 0, y: 0, z: 1))
            _ = scene.meadow.surface.add(tile: Coordinate(x: 0, y: 0, z: -1))
        }
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        if let stateObserver = stateObserver {
            
            viewModel.unsubscribe(stateObserver)
        }
        
        super.stop(then: completion)
    }
}

extension SceneCoordinator {
    
    override func toggle(editor: ViewState) {
        
        switch viewModel.state {
        
        case .editor:
            
            viewModel.state = .meadow
            
        case .meadow:
            
            viewModel.state = .editor
        }
    }
}

extension SceneCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        stopChildren()
        
        guard let spriteView = spriteView,
              let sceneView = sceneView else { return }
        
        switch currentState {
        
        case .editor:
            
            sceneView.isHidden = true
            
            spriteView.isHidden = false
            
        case .meadow:
            
            guard let map = spriteView.scene as? Map else { return }
            
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            
            do {
            
                let data = try encoder.encode(map)
                
                let scene = try decoder.decode(Scene.self, from: data)
                
                sceneView.scene = scene
                sceneView.delegate = scene
            }
            catch {
                
                print("Error: \(error)")
            }
            
            sceneView.isHidden = false
            sceneView.backgroundColor = map.backgroundColor
            sceneView.allowsCameraControl = true
            sceneView.autoenablesDefaultLighting = true
            
            spriteView.isHidden = true
            
        default: break
        }
        
        sceneView.isPlaying = !sceneView.isHidden
        spriteView.isPaused = spriteView.isHidden
    }
}

