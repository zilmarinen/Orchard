//
//  FoliageUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FoliageUtilitiesViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(meadow: Meadow?)
        case foliage(meadow: Meadow)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class FoliageUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
