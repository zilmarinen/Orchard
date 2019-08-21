//
//  FootpathPaintUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FootpathPaintUtilitiesViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case paint(editor: Editor, tool: (FootpathType))
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class FootpathPaintUtilitiesStateObserver: BaseViewModel<ViewState> {
        
    }
}
