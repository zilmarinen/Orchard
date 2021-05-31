//
//  StairsViewModel.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Foundation
import Harvest
import Meadow

extension StairsUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: StairChunk2D)
        case build
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class StairsViewModel: StateObserver<ViewState> {
        
    }
}
