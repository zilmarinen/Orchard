//
//  TerrainTerraformUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class TerrainTerraformUtilitiesViewController: NSViewController {

    lazy var viewModel = {
        
        return TerrainTerraformUtilitiesViewModel(initialState: .empty)
    }()
}

extension TerrainTerraformUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension TerrainTerraformUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        default: break
        }
    }
}
