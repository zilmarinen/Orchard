//
//  WaterPaintUtilityCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 15/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension WaterPaintUtilityCoordinator {
    
    enum ViewState: State {
        
        case empty
        case paint(inspector: WaterInspector, toolType: WaterUtilityCoordinator.ToolType, waterType: WaterType)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func start(with option: StartOption?) {
            
            guard let viewState = option as? WaterUtilityCoordinator.ViewState else { return }
            
            switch viewState {
                
            case .paint(let inspector, let toolType, let waterType):
                
                state = .paint(inspector: inspector, toolType: toolType, waterType: waterType)
                
            default: break
            }
        }
        
        func stop() {
            
            state = .empty
        }
        
        func paint(hit: SceneView.SCNViewHit) {
            
            guard let quad = hit.quad else { return }
            
            switch state {
                
            case .paint(let inspector, let toolType, let waterType):
                
                guard let tile = inspector.inspectable.grid.find(tile: quad.i) else { return }
                
                switch toolType {
                    
                case .edge:
                    
                    guard let joint = hit.joint, let edge = tile.find(edge: joint.i) else { return }
                    
                    edge.topLayer?.waterType = waterType
                    
                case .quad:
                    
                    tile.edges.forEach { (_, edge) in
                        
                        edge.topLayer?.waterType = waterType
                    }
                }
                
            default: break
            }
        }
    }
}
