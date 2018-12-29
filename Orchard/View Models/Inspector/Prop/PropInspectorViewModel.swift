//
//  PropInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

typealias PropInspectable = (props: Props, propNode: PropNode?)

extension PropInspectorViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case prop(editor: Editor, inspectable: PropInspectable)
        
        func shouldTransition(to newState: ViewState) -> THRUtilities.Should<ViewState> {
            
            return .continue
        }
    }
    
    class PropInspectorViewModel: BaseViewModel<ViewState> {
        
    }
}

