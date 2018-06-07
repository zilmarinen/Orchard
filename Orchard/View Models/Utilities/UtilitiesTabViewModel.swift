//
//  UtilitiesTabViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension UtilitiesTabViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case area(Area)
        case foliage(Foliage)
        case footpath(Footpath)
        case terrain(Terrain)
        case water(Water)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
        
        var sortOrder: Int {
            
            switch self {
                
            case .empty: return 0
                
            case .area: return 1
                
            case .foliage: return 2
                
            case .footpath: return 3
                
            case .terrain: return 4
                
            case .water: return 5
            }
        }
    }
    
    class UtilitiesTabViewModel: BaseViewModel<ViewState> {
        
    }
}
