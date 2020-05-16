//
//  UtilityTabViewController+ViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 24/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

extension UtilityTabViewController {
    
    enum ViewState: State {
        
        enum Tab: Int {
            
            case empty
            case actors
        }
        
        case empty
        case actors
        
        func shouldTransition(to newState: ViewState) -> Should<ViewState> {
            
            return .continue
        }
        
        var tab: Tab {
            
            switch self {
                
            case .empty: return .empty
            case .actors: return .actors
            }
        }
    }
    
    class ViewModel: StateObserver<ViewState> {
        
        func clear() {
            
            state = .empty
        }
        
        func select(node: SceneGraphNode) {
            
            print("Utility ViewModel select(node)")
        }
    }
}

