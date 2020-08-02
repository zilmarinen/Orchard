//
//  TerrainUtilityTabViewCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension TerrainUtilityTabViewCoordinator {
    
    enum ViewState: State {
        
        enum Tab: Int {
            
            case empty
            case build
            case paint
            case terraform
        }
        
        case empty
        case build(SceneGraphIdentifiable)
        case paint(SceneGraphIdentifiable)
        case terraform(SceneGraphIdentifiable)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
        
        var tab: Tab {
            
            switch self {
                
            case .empty: return .empty
            case .build: return .build
            case .paint: return .paint
            case .terraform: return .terraform
            }
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func clear() {
            
            state = .empty
        }
    }
}

