//
//  PropBuildUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias PropBuildUtility = (prop: PropPrototype, colorPalette: ColorPalette)

extension PropBuildUtilitiesViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case build(editor: Editor, utility: PropBuildUtility)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class PropBuildUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}

