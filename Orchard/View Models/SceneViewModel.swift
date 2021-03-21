//
//  SceneViewModel.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation
import Meadow

extension SceneCoordinator {
    
    @objc enum ViewState: Int, State, StartOption {
        
        case editor
        case meadow
        
        public func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
    }
    
    class SceneViewModel: StateObserver<ViewState> {
        
    }
}
