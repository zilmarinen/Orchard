//
//  OrchardstateObserver.swift
//  Orchard
//
//  Created by Zack Brown on 31/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias Editor = (meadow: Meadow, delegate: SceneGraphDelegate)

extension OrchardViewController {
    
    enum ViewState: THRUtilities.State {
        
        case editor(editor: Editor)
        case loading(editor: Editor, map: Map)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class OrchardStateObserver: BasestateObserver<ViewState> {
        
        
    }
}
