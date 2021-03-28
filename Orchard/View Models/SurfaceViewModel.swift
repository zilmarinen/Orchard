//
//  SurfaceViewModel.swift
//
//  Created by Zack Brown on 11/03/2021.
//

import Foundation
import Meadow

extension SurfaceUtilityCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: SurfaceTile2D)
        case material
        case elevation
        case edge
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class SurfaceViewModel: StateObserver<ViewState> {
        
    }
}
