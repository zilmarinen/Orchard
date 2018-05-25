//
//  TerrainPaintUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class TerrainPaintUtilitiesViewController: NSViewController {

    lazy var viewModel = {
        
        return TerrainPaintUtilitiesViewModel(initialState: .empty)
    }()
}

extension TerrainPaintUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension TerrainPaintUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        default: break
        }
    }
}
