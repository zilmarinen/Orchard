//
//  UtilitiesViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import THRUtilities

extension UtilitiesTabViewController {
    
    enum ViewState: Int, State {
        
        case area
        case foliage
        case footpath
        case terrain
        case water
        
        func shouldTransition(to newState: UtilitiesTabViewController.ViewState) -> Should<UtilitiesTabViewController.ViewState> {
            
            return .continue
        }
    }

    class UtilitiesViewModel: BaseViewModel<UtilitiesTabViewController.ViewState> {
        
    }
}
