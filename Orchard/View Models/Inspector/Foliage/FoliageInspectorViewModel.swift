//
//  FoliageInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias FoliageInspectable = (grid: Foliage, chunk: FoliageChunk?, tile: FoliageTile?, node: FoliageNode?)

extension FoliageInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case foliage(editor: Editor, inspectable: FoliageInspectable)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class FoliageInspectorViewModel: BaseViewModel<ViewState> {
        
    }
}
