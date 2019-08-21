//
//  TerrainUtilitiesTabstateObserver.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension TerrainUtilitiesTabViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case build(editor: Editor)
        case terraform(editor: Editor)
        case paint(editor: Editor)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .build: return 1
                
            case .terraform: return 2
                
            case .paint: return 3
            }
        }
    }
    
    class TerrainUtilitiesTabStateObserver: BasestateObserver<ViewState> {
        
    }
}
