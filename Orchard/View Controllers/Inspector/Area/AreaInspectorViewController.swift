//
//  AreaInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class AreaInspectorViewController: NSViewController {

    lazy var viewModel = {
        
        return AreaInspectorViewModel(initialState: .empty)
    }()
}

extension AreaInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension AreaInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        default: break
        }
    }
}
