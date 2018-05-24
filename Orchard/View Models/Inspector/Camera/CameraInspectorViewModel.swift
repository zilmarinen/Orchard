//
//  CameraInspectorViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 24/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension CameraInspectorViewController {
    
    enum ViewState: State {
        
        case empty
        case inspecting(CameraJib)
        
        func shouldTransition(to newState: CameraInspectorViewController.ViewState) -> Should<CameraInspectorViewController.ViewState> {
            
            return .continue
        }
    }
    
    class CameraInspectorViewModel: BaseViewModel<CameraInspectorViewController.ViewState> {
        
    }
}
