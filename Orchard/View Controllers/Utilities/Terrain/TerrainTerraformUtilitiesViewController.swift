//
//  TerrainTerraformUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class TerrainTerraformUtilitiesViewController: NSViewController {

    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var smoothCheckBox: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .terraform(let meadow, let toolType, _):
            
            let smooth = (sender.state == .on)
            
            viewModel.state = .terraform(meadow: meadow, toolType: toolType, smooth: smooth)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .terraform(let meadow, _, let smooth):
            
            let selectedToolType = ToolType(rawValue: sender.indexOfSelectedItem)!
            
            viewModel.state = .terraform(meadow: meadow, toolType: selectedToolType, smooth: smooth)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainTerraformUtilitiesViewModel(initialState: .empty(meadow: nil))
    }()
    
    var cursorModelCallbackReference: UUID?
}

extension TerrainTerraformUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainTerraformUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let meadow):
            
            guard let meadow = meadow else { break }
            
            meadow.input.cursorModel.tracksIdleEvents = false
            
            if let reference = cursorModelCallbackReference {
                
                meadow.input.cursorModel.unsubscribe(reference)
            }
            
        case .terraform(let meadow, let toolType, let smooth):
            
            meadow.input.cursorModel.tracksIdleEvents = true
            
            cursorModelCallbackReference = meadow.input.cursorModel.subscribe(stateDidChange(from:to:))
            
            toolTypePopUp.removeAllItems()
            
            toolTypePopUp.addItem(withTitle: "Corner")
            toolTypePopUp.addItem(withTitle: "Edge")
            toolTypePopUp.addItem(withTitle: "Tile")
            
            toolTypePopUp.selectItem(at: toolType.rawValue)
            
            smoothCheckBox.state = (smooth ? .on : .off)
        }
    }
}

extension TerrainTerraformUtilitiesViewController: CursorModelObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .terraform(let meadow, let toolType, let smooth):
            
            switch to {
                
            case .idle(let position):
                
                print("terraform - idle: \(position)")
                
            case .down(let position, let inputType):
                
                print("terraform - down: \(inputType) \(position)")
                
            case .tracking(let position, let inputType, let startPosition):
                
                print("terraform - tracking: \(inputType) \(startPosition) -> \(position)")
                
            case .up(let position, let inputType, let startPosition):
                
                print("terraform - up: \(inputType) \(startPosition) -> \(position)")
            }
            
        default: break
        }
    }
}
