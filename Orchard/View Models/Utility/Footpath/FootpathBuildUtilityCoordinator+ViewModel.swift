//
//  FootpathBuildUtilityCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 16/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension FootpathBuildUtilityCoordinator {
    
    enum ViewState: State {
        
        case empty
        case build(inspector: FootpathInspector, toolType: FootpathUtilityCoordinator.ToolType, footpathType: FootpathType)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func start(with option: StartOption?) {
            
            guard let viewState = option as? FootpathUtilityCoordinator.ViewState else { return }
            
            switch viewState {
                
            case .build(let inspector, let toolType, let footpathType):
                
                state = .build(inspector: inspector, toolType: toolType, footpathType: footpathType)
                
            default: break
            }
        }
        
        func stop() {
            
            state = .empty
        }
        
        func build(hit: SceneView.SCNViewHit) {
            
            guard let quad = hit.quad else { return }
            
            switch state {
                
            case .build(let inspector, let toolType, let footpathType):
                
                switch toolType {
                    
                case .edge:
                    
                    guard let joint = hit.joint else { return }
                    
                    if let tile = inspector.inspectable.grid.find(tile: quad.i), tile.find(edge: joint.i) == nil {
                        
                        guard let layer = inspector.inspectable.grid.add(layer: quad.i, edgeIdentifier: joint.i) else { return }
                        
                            layer.footpathType = footpathType
                    }
                    else {
                    
                        guard let layer = inspector.inspectable.grid.add(layer: quad.i, edgeIdentifier: joint.i) else { return }
                    
                        layer.footpathType = footpathType
                    }
                    
                case .quad:
                    
                    guard inspector.inspectable.grid.find(tile: quad.i) == nil else { return }
                    
                    guard let tile = inspector.inspectable.grid.add(tile: quad.i) else { return }
                    
                    tile.edges.forEach { (_, edge) in
                        
                        edge.topLayer?.footpathType = footpathType
                    }
                }
                
            default: break
            }
        }
        
        func remove(hit: SceneView.SCNViewHit) {
            
            guard let quad = hit.quad else { return }
            
            switch state {
                
            case .build(let inspector, let toolType, _):
                
                guard let tile = inspector.inspectable.grid.find(tile: quad.i) else { return }
                
                switch toolType {
                    
                case .edge:
                    
                    guard let joint = hit.joint, let edge = tile.find(edge: joint.i), edge.totalLayers > 0 else { return }
                    
                    edge.remove(layer: edge.totalLayers - 1)
                    
                case .quad:
                    
                    tile.edges.forEach { (_, edge) in
                        
                        if edge.totalLayers > 0 {
                            
                            edge.remove(layer: edge.totalLayers - 1)
                        }
                    }
                }
                
            default: break
            }
        }
    }
}
