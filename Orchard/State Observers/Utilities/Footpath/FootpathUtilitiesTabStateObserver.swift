//
//  FootpathUtilitiesTabstateObserver.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FootpathUtilitiesTabViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case build(editor: Editor, tool: (footpathType: FootpathType, slope: FootpathNode.Slope?))
        case paint(editor: Editor, tool: (FootpathType))
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .build: return 1
                
            case .paint: return 2
            }
        }
    }
    
    class FootpathUtilitiesTabStateObserver: BasestateObserver<ViewState> {
        
    }
}
