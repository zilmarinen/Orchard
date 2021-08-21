//
//  BridgeViewModel.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Foundation
import Harvest
import Meadow

extension BridgeUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: BridgeTile2D)
        case build
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class BridgeViewModel: StateObserver<ViewState> {
        
    }
}
