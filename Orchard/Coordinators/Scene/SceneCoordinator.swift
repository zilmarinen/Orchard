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
        
        sceneView.library = try? device.makeDefaultLibrary(bundle: Meadow.bundle)
        
        spriteView.ignoresSiblingOrder = true
        
        if let harvest = option as? Harvest {
            
            let scene = Scene2D(size: Constants.size, harvest: harvest)
            
            scene.isPaused = false
            
            spriteView.presentScene(scene)
        }
        
        if spriteView.scene == nil {
        
            let scene = Scene2D(size: Constants.size)
        
            scene.isPaused = false
            scene.backgroundColor = Color(red: 0.91, green: 0.91, blue: 0.91).color
        
            spriteView.presentScene(scene)
            
            _ = scene.harvest.surface.add(tile: .zero)
//
//            let size = 32
//            let halfSize = size / 2
//            let y = Int(World.Constants.ceiling / 2)
//
//            for x in -halfSize...halfSize {
//
//                for z in -halfSize...halfSize {
//
//                    _ = scene.harvest.surface.add(tile: Coordinate(x: x, y: y, z: z)) { tile in
//
//                        if tile.coordinate.x == 0 && tile.coordinate.z == 0 {
//
//                            tile.tileType = .init(primary: .grass, secondary: .grass)
//                        }
//                    }
//                }
//            }
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
            
            guard let map = spriteView.scene as? Scene2D else { return }
            
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
            
            spriteView.isHidden = true
            
        default: break
        }
        
        sceneView.isPlaying = !sceneView.isHidden
        spriteView.isPaused = spriteView.isHidden
    }
}

