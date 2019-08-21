//
//  AreaArchitectureUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias AreaArchitectureUtility = (colorPalette: Editor, other: Editor)

extension AreaArchitectureUtilitiesViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case architecture(editor: Editor, utility: AreaArchitectureUtility)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class AreaArchitectureUtilitiesStateObserver: BaseViewModel<ViewState> {
        
    }
}

