//
//  SidebarTabViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 30/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension SidebarTabViewController {
    
    enum ViewState: State {
        
        case empty
        case inspector(Meadow)
        case utilities(Meadow)
        
        func shouldTransition(to newState: SidebarTabViewController.ViewState) -> Should<SidebarTabViewController.ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .inspector: return 1
                
            case .utilities: return 2
            }
        }
    }
    
    class SidebarTabViewModel: BaseViewModel<SidebarTabViewController.ViewState> {
        
    }
}
