//
//  TerrainUtilitiesTabViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension TerrainUtilitiesTabViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(meadow: Meadow?)
        case build(meadow: Meadow)
        case terraform(meadow: Meadow)
        case paint(meadow: Meadow)
        
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
    
    class TerrainUtilitiesTabViewModel: BaseViewModel<ViewState> {
        
    }
}
