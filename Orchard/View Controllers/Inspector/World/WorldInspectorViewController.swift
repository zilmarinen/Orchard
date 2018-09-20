//
//  WorldInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 16/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class WorldInspectorViewController: NSViewController {
    
    lazy var viewModel = {
        
        return WorldInspectorViewModel(initialState: .empty)
    }()
}

extension WorldInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension WorldInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let world):
            
            break
            
        default: break
        }
    }
}
