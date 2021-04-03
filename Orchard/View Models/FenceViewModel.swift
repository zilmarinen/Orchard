//
//  FenceViewModel.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Foundation
import Meadow

extension FenceUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: FenceTile2D)
        case build
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class FenceViewModel: StateObserver<ViewState> {
        
    }
}
