//
//  WaterUtilityCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 15/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension WaterUtilityCoordinator {
    
    enum Utility: Int, CaseIterable {
        
        case build
        case paint
        
        var title: String {
            
            switch self {
                
            case .build: return "Build"
            case .paint: return "Paint"
            }
        }
    }
    
    enum ToolType: Int, CaseIterable {
        
        case edge
        case quad
        
        var title: String {
            
            switch self {
                
            case .edge: return "Edge"
            case .quad: return "Quad"
            }
        }
    }
    
    enum ViewState: State, StartOption {
        
        case empty
        case build(inspector: WaterInspector, toolType: ToolType, waterType: WaterType)
        case paint(inspector: WaterInspector, toolType: ToolType, waterType: WaterType)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func start(with option: StartOption?) {
            
            guard let node = option as? SceneGraphIdentifiable, let inspector = WaterInspector(node: node) else { return }
            
            state = .build(inspector: inspector, toolType: .quad, waterType: .saltWater)
        }
        
        func stop() {
            
            state = .empty
        }
        
        func `switch`(utility: Utility) {
            
            switch utility {
                
            case .build:
                
                switch state {
                    
                case .paint(let inspector, let toolType, let waterType):
                    
                    state = .build(inspector: inspector, toolType: toolType, waterType: waterType)
                    
                default: break
                }
                
            case .paint:
                
                switch state {
                    
                case .build(let inspector, let toolType, let waterType):
                    
                    state = .paint(inspector: inspector, toolType: toolType, waterType: waterType)
                    
                default: break
                }
            }
        }
        
        func set(toolType: ToolType) {
            
            switch state {
                
            case .build(let inspector, _, let waterType):
                
                state = .build(inspector: inspector, toolType: toolType, waterType: waterType)
                
            case .paint(let inspector, _, let waterType):
                
                state = .paint(inspector: inspector, toolType: toolType, waterType: waterType)
                
            default: break
            }
        }
        
        func set(waterType: WaterType) {
            
            switch state {
                
            case .build(let inspector, let toolType, _):
                
                state = .build(inspector: inspector, toolType: toolType, waterType: waterType)
                
            case .paint(let inspector, let toolType, _):
                
                state = .paint(inspector: inspector, toolType: toolType, waterType: waterType)
                
            default: break
            }
        }
    }
}
