//
//  AreaUtilityCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 16/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension AreaUtilityCoordinator {
    
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
        case build(inspector: AreaInspector, toolType: ToolType, areaType: AreaType)
        case paint(inspector: AreaInspector, toolType: ToolType, areaType: AreaType)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func start(with option: StartOption?) {
            
            guard let node = option as? SceneGraphIdentifiable, let inspector = AreaInspector(node: node) else { return }
            
            state = .build(inspector: inspector, toolType: .quad, areaType: .brick)
        }
        
        func stop() {
            
            state = .empty
        }
        
        func `switch`(utility: Utility) {
            
            switch utility {
                
            case .build:
                
                switch state {
                    
                case .paint(let inspector, let toolType, let areaType):
                    
                    state = .build(inspector: inspector, toolType: toolType, areaType: areaType)
                    
                default: break
                }
                
            case .paint:
                
                switch state {
                    
                case .build(let inspector, let toolType, let areaType):
                    
                    state = .paint(inspector: inspector, toolType: toolType, areaType: areaType)
                    
                default: break
                }
            }
        }
        
        func set(toolType: ToolType) {
            
            switch state {
                
            case .build(let inspector, _, let areaType):
                
                state = .build(inspector: inspector, toolType: toolType, areaType: areaType)
                
            case .paint(let inspector, _, let areaType):
                
                state = .paint(inspector: inspector, toolType: toolType, areaType: areaType)
                
            default: break
            }
        }
        
        func set(areaType: AreaType) {
            
            switch state {
                
            case .build(let inspector, let toolType, _):
                
                state = .build(inspector: inspector, toolType: toolType, areaType: areaType)
                
            case .paint(let inspector, let toolType, _):
                
                state = .paint(inspector: inspector, toolType: toolType, areaType: areaType)
                
            default: break
            }
        }
    }
}
