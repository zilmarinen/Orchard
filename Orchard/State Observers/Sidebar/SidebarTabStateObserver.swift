//
//  SidebarTabViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 30/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension SidebarTabViewController {
    
    enum Tab: Int {
        
        case empty
        case inspector
        case utility
    }
    
    enum ViewState: THRUtilities.State {
        
        case empty(editor: Editor?)
        case inspector(editor: Editor, child: SceneGraphChild)
        case utility(editor: Editor)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
        
        var tab: Tab {
            
            switch self {
                
            case .empty: return Tab.empty
            case .inspector: return Tab.inspector
            case .utility: return Tab.utility
            }
        }
    }
    
    class SidebarTabStateObserver: BaseViewModel<ViewState> {
        
    }
}
