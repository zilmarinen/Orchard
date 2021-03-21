//
//  FootpathViewModel.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation
import Meadow

extension FootpathUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: FootpathTile2D)
        case material
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class FootpathViewModel: StateObserver<ViewState> {
        
    }
}
