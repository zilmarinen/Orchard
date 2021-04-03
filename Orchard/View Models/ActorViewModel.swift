//
//  ActorViewModel.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import Foundation
import Meadow

extension ActorUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: Actor2D)
        case placement
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class ActorViewModel: StateObserver<ViewState> {
        
    }
}
