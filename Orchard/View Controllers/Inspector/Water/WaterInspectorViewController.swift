//
//  WaterInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class WaterInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkCount: NSTextField!

    lazy var viewModel = {
        
        return WaterInspectorViewModel(initialState: .empty)
    }()
}

extension WaterInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension WaterInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let water, let waterNode):
            
            chunkCount.stringValue = "\(water.totalChildren)"
            
        default: break
        }
    }
}
