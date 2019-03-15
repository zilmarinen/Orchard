//
//  WaterBuildUtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 18/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension WaterBuildUtilitiesViewController {
    
    enum ToolType: Int {
        
        case edge
        case tile
    }
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case build(editor: Editor, tool: (toolType: ToolType, waterType: WaterType))
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class WaterBuildUtilitiesViewModel: BaseViewModel<ViewState> {
        
    }
}
