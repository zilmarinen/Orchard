//
//  AreaBuildUtilitiesstateObserver.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension AreaBuildUtilitiesViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case build(editor: Editor, tool: (externalEdges: Bool, edgeType: AreaNodeEdgeType, floor: AreaNodeFloor, internalEdgeFace: AreaNodeEdgeFace, externalEdgeFace: AreaNodeEdgeFace))
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class AreaBuildUtilitiesStateObserver: BasestateObserver<ViewState> {
        
    }
}
