//
//  AreaBuildUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias AreaBuildUtility = (colorPalette: ColorPalette, other: ColorPalette)

extension AreaBuildUtilitiesViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case build(editor: Editor, utility: AreaBuildUtility)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class AreaBuildUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
