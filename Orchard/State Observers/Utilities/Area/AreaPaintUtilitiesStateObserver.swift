//
//  AreaPaintUtilitiesstateObserver.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias AreaPaintUtility = (floorColorPalette: ColorPalette, externalColorPalette: ColorPalette, internalColorPalette: ColorPalette)

extension AreaPaintUtilitiesViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case paint(editor: Editor, utility: AreaPaintUtility)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class AreaPaintUtilitiesStateObserver: BasestateObserver<ViewState> {
        
    }
}

