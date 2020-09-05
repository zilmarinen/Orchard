//
//  TerrainUtilityViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 02/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Terrace

extension TerrainUtilityViewController {
    
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
    
    enum ViewState: State {
        
        case empty
        case build(inspector: TerrainInspector)
        case paint(inspector: TerrainInspector)
        case terraform(inspector: TerrainInspector)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        var cursorObserver: UUID? = nil
        
        func start(inspector: TerrainInspector) {
            
            state = .build(inspector: inspector)
        }
        
        func stop() {
            
            state = .empty
        }
    }
}
