//
//  InspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import THRUtilities

extension InspectorTabViewController {
    
    enum ViewState: Int, State {
        
        case area
        case foliage
        case footpath
        case terrain
        case water
        
        func shouldTransition(to newState: InspectorTabViewController.ViewState) -> Should<InspectorTabViewController.ViewState> {
            
            return .continue
        }
    }
    
    class InspectorViewModel: BaseViewModel<InspectorTabViewController.ViewState> {
        
    }
}
