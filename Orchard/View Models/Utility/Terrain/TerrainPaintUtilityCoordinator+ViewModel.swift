//
//  TerrainPaintUtilityCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 08/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension TerrainPaintUtilityCoordinator {
    
    enum ViewState: State {
        
        case empty
        case paint(inspector: TerrainInspector, toolType: TerrainUtilityCoordinator.ToolType, terrainType: TerrainType)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func start(with option: StartOption?) {
            
            guard let viewState = option as? TerrainUtilityCoordinator.ViewState else { return }
            
            switch viewState {
                
            case .paint(let inspector, let toolType, let terrainType):
                
                state = .paint(inspector: inspector, toolType: toolType, terrainType: terrainType)
                
            default: break
            }
        }
        
        func stop() {
            
            state = .empty
        }
        
        func paint(hit: SceneView.SCNViewHit) {
            
            guard let quad = hit.quad else { return }
            
            switch state {
                
            case .paint(let inspector, let toolType, let terrainType):
                
                guard let tile = inspector.inspectable.grid.find(tile: quad.i) else { return }
                
                switch toolType {
                    
                case .edge:
                    
                    guard let joint = hit.joint, let edge = tile.find(edge: joint.i) else { return }
                    
                    edge.topLayer?.terrainType = terrainType
                    
                case .quad:
                    
                    tile.edges.forEach { (_, edge) in
                        
                        edge.topLayer?.terrainType = terrainType
                    }
                }
                
            default: break
            }
        }
    }
}
