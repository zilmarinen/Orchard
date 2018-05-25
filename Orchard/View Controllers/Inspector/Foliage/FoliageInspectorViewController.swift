//
//  FoliageInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class FoliageInspectorViewController: NSViewController {

    lazy var viewModel = {
        
        return FoliageInspectorViewModel(initialState: .empty)
    }()
}

extension FoliageInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension FoliageInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        default: break
        }
    }
}
