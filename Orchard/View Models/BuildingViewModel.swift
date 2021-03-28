//
//  BuildingsViewModel.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Foundation
import Meadow

extension BuildingUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: BuildingChunk2D)
        case build
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class BuildingViewModel: StateObserver<ViewState> {
        
    }
}
