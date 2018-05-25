//
//  TerrainBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class TerrainBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    
    lazy var viewModel = {
        
        return TerrainBuildUtilitiesViewModel(initialState: .empty)
    }()
}

extension TerrainBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension TerrainBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let terrain):
            
            terrainTypePopUp.removeAllItems()
            
            terrain.availableTerrainTypes.forEach { terrainType in
                
                terrainTypePopUp.addItem(withTitle: terrainType.name)
            }
            
        default: break
        }
    }
}
