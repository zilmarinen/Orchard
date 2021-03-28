//
//  FoliageViewModel.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Foundation
import Meadow

extension FoliageUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: FoliageChunk2D)
        case plant
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class FoliageViewModel: StateObserver<ViewState> {
        
    }
}
