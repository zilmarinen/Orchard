//
//  TerrainUtilityCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 02/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension TerrainUtilityCoordinator {
    
    enum Utility: Int, CaseIterable {
        
        case build
        case paint
        case terraform
        
        var title: String {
            
            switch self {
                
            case .build: return "Build"
            case .paint: return "Paint"
            case .terraform: return "Terraform"
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
        case build(inspector: TerrainInspector, toolType: ToolType, terrainType: TerrainType)
        case paint(inspector: TerrainInspector, toolType:ToolType, terrainType: TerrainType)
        case terraform(inspector: TerrainInspector)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func start(with option: StartOption?) {
            
            guard let node = option as? SceneGraphIdentifiable, let inspector = TerrainInspector(node: node) else { return }
            
            state = .build(inspector: inspector, toolType: .quad, terrainType: .bedrock)
        }
        
        func stop() {
            
            state = .empty
        }
        
        func `switch`(utility: Utility) {
            
            switch utility {
                
            case .build:
                
                switch state {
                    
                case .paint(let inspector, _, _),
                     .terraform(let inspector):
                    
                    state = .build(inspector: inspector, toolType: .quad, terrainType: .bedrock)
                    
                default: break
                }
                
            case .paint:
                
                switch state {
                    
                case .build(let inspector, _, _),
                     .terraform(let inspector):
                    
                    state = .paint(inspector: inspector, toolType: .quad, terrainType: .bedrock)
                    
                default: break
                }
                
            case .terraform:
                
                switch state {
                    
                case .build(let inspector, _, _),
                     .paint(let inspector, _, _):
                    
                    state = .terraform(inspector: inspector)
                    
                default: break
                }
            }
        }
        
        func set(toolType: ToolType) {
            
            switch state {
                
            case .build(let inspector, _, let terrainType):
                
                state = .build(inspector: inspector, toolType: toolType, terrainType: terrainType)
                
            case .paint(let inspector, _, let terrainType):
                
                state = .paint(inspector: inspector, toolType: toolType, terrainType: terrainType)
                
            default: break
            }
        }
        
        func set(terrainType: TerrainType) {
            
            switch state {
                
            case .build(let inspector, let toolType, _):
                
                state = .build(inspector: inspector, toolType: toolType, terrainType: terrainType)
                
            case .paint(let inspector, let toolType, _):
                
                state = .paint(inspector: inspector, toolType: toolType, terrainType: terrainType)
                
            default: break
            }
        }
    }
}
