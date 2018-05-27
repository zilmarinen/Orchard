//
//  TerrainTerraformUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class TerrainTerraformUtilitiesViewController: NSViewController {

    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var smoothCheckBox: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .inspecting(let terrain, let toolType, _):
            
            let smooth = (sender.state == .on)
            
            viewModel.state = .inspecting(terrain, toolType, smooth)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let terrain, _, let smooth):
            
            let selectedToolType = ToolType(rawValue: sender.indexOfSelectedItem)!
            
            viewModel.state = .inspecting(terrain, selectedToolType, smooth)
            
        default: break
        }
    }
    
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
            
        case .inspecting(_, let toolType, let smooth):
            
            toolTypePopUp.removeAllItems()
            
            toolTypePopUp.addItem(withTitle: "Corner")
            toolTypePopUp.addItem(withTitle: "Edge")
            toolTypePopUp.addItem(withTitle: "Tile")
            
            toolTypePopUp.selectItem(at: toolType.rawValue)
            
            smoothCheckBox.state = (smooth ? .on : .off)
            
        default: break
        }
    }
}
