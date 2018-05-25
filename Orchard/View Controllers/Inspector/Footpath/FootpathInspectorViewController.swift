//
//  FootpathInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class FootpathInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkCount: NSTextField!

    lazy var viewModel = {
        
        return FootpathInspectorViewModel(initialState: .empty)
    }()
}

extension FootpathInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension FootpathInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let footpath):
            
            chunkCount.stringValue = "\(footpath.totalChildren)"
            
        default: break
        }
    }
}
