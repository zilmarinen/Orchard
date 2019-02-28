//
//  AreaInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias AreaInspectable = (grid: Area, chunk: AreaChunk?, tile: AreaTile?, node: AreaNode<AreaNodeEdge>?, edge: AreaNodeEdge?)

extension AreaInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case area(editor: Editor, inspectable: AreaInspectable)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class AreaInspectorViewModel: BaseViewModel<ViewState> {
        
    }
}
