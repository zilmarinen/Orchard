//
//  FoliagePaintUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FoliagePaintUtilitiesViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case paint(editor: Editor)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class FoliagePaintUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
