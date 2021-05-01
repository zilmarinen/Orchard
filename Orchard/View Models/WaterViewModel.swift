//
//  WaterViewModel.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Foundation
import Harvest
import Meadow

extension WaterUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: WaterTile2D)
        case material
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class WaterViewModel: StateObserver<ViewState> {
        
    }
}
