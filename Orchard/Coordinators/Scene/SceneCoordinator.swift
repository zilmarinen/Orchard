//
//  SceneCoordinator.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Harvest
import Meadow
import SpriteKit

class SceneCoordinator: Coordinator<SceneViewController> {
    
    enum Constants {
        
        static let size = CGSize(width: 127, height: 95)
    }
    
    lazy var viewModel: SceneViewModel = {
        
        return SceneViewModel(initialState: .editor)
    }()
    
    override init(controller: SceneViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let spriteView = spriteView,
              let sceneView = sceneView,
              let device = sceneView.device else { fatalError("Invalid start option") }
        
        sceneView.library = try? device.makeDefaultLibrary(bundle: Map.bundle)
        
        spriteView.ignoresSiblingOrder = true
        
        if let map = option as? Map2D {
            
            let scene = Scene2D(size: Constants.size, map: map)
            
            scene.isPaused = false
            
            spriteView.presentScene(scene)
        }
        
        if spriteView.scene == nil {
        
            let scene = Scene2D(size: Constants.size)
        
            scene.isPaused = false
            scene.backgroundColor = Color(red: 0.91, green: 0.91, blue: 0.91).color
        
            spriteView.presentScene(scene)
            
            _ = scene.map.surface.add(tile: .zero)
        }
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
            
            guard let scene = spriteView.scene as? Scene2D else { return }
            
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            
            do {
            
                let data = try encoder.encode(scene)
                
                let scene = try decoder.decode(Scene.self, from: data)
                
                sceneView.scene = scene
                sceneView.delegate = scene
            }
            catch {
                
                print("Error: \(error)")
            }
            
            sceneView.isHidden = false
            sceneView.backgroundColor = scene.backgroundColor
            sceneView.allowsCameraControl = true
            
            spriteView.isHidden = true
            
        default: break
        }
        
        sceneView.isPlaying = !sceneView.isHidden
        spriteView.isPaused = spriteView.isHidden
    }
}

