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
    
    @IBOutlet weak var clearColorPopUp: NSPopUpButton!
    @IBOutlet weak var clearColorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let world):
            
            let selectedColor = ColorPalettes.shared.allColors[sender.indexOfSelectedItem]
            
            world.floor.color = selectedColor
            
            viewModel.state = .inspecting(world)
            
        default: break
        }
    }
    
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
            
            clearColorPopUp.removeAllItems()
            
            ColorPalettes.shared.allColors.forEach { color in
                
                clearColorPopUp.addItem(withTitle: color.name)
            }
            
            if let floorColor = world.floor.color, let index = ColorPalettes.shared.allColors.index(of: floorColor) {
                
                clearColorPopUp.selectItem(at: index)
                
                clearColorPaletteView.color = floorColor
            }
            
        default: break
        }
    }
}

