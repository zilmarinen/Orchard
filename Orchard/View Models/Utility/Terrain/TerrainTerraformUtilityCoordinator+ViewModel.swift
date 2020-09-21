//
//  TerrainTerraformUtilityCoordinator+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 08/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Terrace

extension TerrainTerraformUtilityCoordinator {
    
    enum ViewState: State {
        
        case empty
        case terraform(inspector: TerrainInspector)
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func start(with option: StartOption?) {
            
            guard let viewState = option as? TerrainUtilityCoordinator.ViewState else { return }
            
            switch viewState {
                
            case .terraform(let inspector):
                
                state = .terraform(inspector: inspector)
                
            default: break
            }
        }
        
        func stop() {
            
            state = .empty
        }
    }
}
