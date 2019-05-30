//
//  SceneGraphViewModel.swift
//  Orchard
//
//  Created by Zack Brown on 31/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

extension SceneGraphViewController {
    
    enum ViewState: THRUtilities.State {
        
        case empty
        case sceneGraph(scene: SceneKitScene, child: SceneGraphChild?)
        
        func shouldTransition(to newState: SceneGraphViewController.ViewState) -> THRUtilities.Should<SceneGraphViewController.ViewState> {
            
            return .continue
        }
    }
    
    class SceneGraphViewModel: BaseViewModel<ViewState> {
        
    }
}
