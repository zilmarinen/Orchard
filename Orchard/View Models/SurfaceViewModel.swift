//
//  SurfaceViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 11/03/2021.
//

import Foundation
import Meadow

extension SurfaceUtilityCoordinator {
    
    public enum ViewState: State, StartOption {
        
        case empty
        case inspector(tile: SurfaceTile2D)
        case material
        case elevation
        
        case thing(String)
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class SurfaceViewModel: StateObserver<ViewState> {
        
    }
}
