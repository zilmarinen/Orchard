//
//  PortalViewModel.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation
import Meadow

extension PortalCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: Portal2D)
        case build
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class PortalViewModel: StateObserver<ViewState> {
        
    }
}
