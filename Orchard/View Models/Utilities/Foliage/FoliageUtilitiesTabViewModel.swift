//
//  FoliageUtilitiesTabViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 28/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension FoliageUtilitiesTabViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case build(editor: Editor)
        case paint(editor: Editor)
        
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
    
    class FoliageUtilitiesTabViewModel: BaseViewModel<ViewState> {
        
    }
}
