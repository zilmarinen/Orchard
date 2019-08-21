//
//  WaterInspectorstateObserver.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias WaterInspectable = (grid: Water, chunk: WaterChunk?, tile: WaterTile?, node: WaterNode<WaterNodeEdge>?, edge: WaterNodeEdge?)

extension WaterInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case water(editor: Editor, inspectable: WaterInspectable)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class WaterInspectorStateObserver: BasestateObserver<ViewState> {
        
    }
}
