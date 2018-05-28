//
//  FootpathUtilitiesTabViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FootpathUtilitiesTabViewController {
    
    enum ViewState: State {
        
        case empty
        
        func shouldTransition(to newState: FootpathUtilitiesTabViewController.ViewState) -> Should<FootpathUtilitiesTabViewController.ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
            }
        }
    }
    
    class FootpathUtilitiesTabViewModel: BaseViewModel<FootpathUtilitiesTabViewController.ViewState> {
        
    }
}
