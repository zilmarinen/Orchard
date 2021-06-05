//
//  SeamViewModel.swift
//
//  Created by Zack Brown on 01/06/2021.
//


import Foundation
import Harvest
import Meadow

extension SeamCoordinator {
    
    enum ViewState: State, StartOption {
        
        case empty
        case inspector(node: SeamTile2D)
        case stitch
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class SeamViewModel: StateObserver<ViewState> {
        
    }
}
