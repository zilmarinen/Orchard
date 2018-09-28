//
//  WaterInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias FootpathInspectable = (grid: Footpath, chunk: FootpathChunk?, tile: FootpathTile?, node: FootpathNode?)

extension FootpathInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case footpath(editor: Editor, inspectable: FootpathInspectable)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class FootpathInspectorViewModel: BaseViewModel<ViewState> {
        
    }
}
