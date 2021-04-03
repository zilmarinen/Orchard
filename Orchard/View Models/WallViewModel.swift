//
//  WallViewModel.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import Foundation
import Meadow

extension WallUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: WallTile2D)
        case build
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class WallViewModel: StateObserver<ViewState> {
        
    }
}
