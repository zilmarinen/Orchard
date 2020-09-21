//
//  FootpathUtilityCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 16/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension FootpathUtilityCoordinator {
    
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
        case build(inspector: FootpathInspector, toolType: ToolType, footpathType: FootpathType)
        case paint(inspector: FootpathInspector, toolType: ToolType, footpathType: FootpathType)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func start(with option: StartOption?) {
            
            guard let node = option as? SceneGraphIdentifiable, let inspector = FootpathInspector(node: node) else { return }
            
            state = .build(inspector: inspector, toolType: .quad, footpathType: .dirt)
        }
        
        func stop() {
            
            state = .empty
        }
        
        func `switch`(utility: Utility) {
            
            switch utility {
                
            case .build:
                
                switch state {
                    
                case .paint(let inspector, let toolType, let footpathType):
                    
                    state = .build(inspector: inspector, toolType: toolType, footpathType: footpathType)
                    
                default: break
                }
                
            case .paint:
                
                switch state {
                    
                case .build(let inspector, let toolType, let footpathType):
                    
                    state = .paint(inspector: inspector, toolType: toolType, footpathType: footpathType)
                    
                default: break
                }
            }
        }
        
        func set(toolType: ToolType) {
            
            switch state {
                
            case .build(let inspector, _, let footpathType):
                
                state = .build(inspector: inspector, toolType: toolType, footpathType: footpathType)
                
            case .paint(let inspector, _, let footpathType):
                
                state = .paint(inspector: inspector, toolType: toolType, footpathType: footpathType)
                
            default: break
            }
        }
        
        func set(footpathType: FootpathType) {
            
            switch state {
                
            case .build(let inspector, let toolType, _):
                
                state = .build(inspector: inspector, toolType: toolType, footpathType: footpathType)
                
            case .paint(let inspector, let toolType, _):
                
                state = .paint(inspector: inspector, toolType: toolType, footpathType: footpathType)
                
            default: break
            }
        }
    }
}

