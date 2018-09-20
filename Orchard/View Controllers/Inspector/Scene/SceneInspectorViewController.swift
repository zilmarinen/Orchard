//
//  SceneInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 21/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class SceneInspectorViewController: NSViewController {

    @IBOutlet weak var nameTextField: NSTextField!
    
    @IBOutlet weak var clearColorPopUp: NSPopUpButton!
    @IBOutlet weak var clearColorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let meadow):
            
            let selectedColor = ColorPalettes.shared?.allColors[sender.indexOfSelectedItem]
            
            meadow.world.floor.color = selectedColor
            
            viewModel.state = .inspecting(meadow)
            
        default: break
        }
    }
    
    @IBAction func textField(_ textField: NSTextField) {
        
        switch viewModel.state {
            
        case .inspecting(let meadow):
            
            meadow.rootNode.name = textField.stringValue
            
            viewModel.state = .inspecting(meadow)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return SceneInspectorViewModel(initialState: .empty)
    }()
}

extension SceneInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension SceneInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let meadow):
            
            clearColorPopUp.removeAllItems()
            
            nameTextField.stringValue = meadow.rootNode.name ?? ""
            
            ColorPalettes.shared?.allColors.forEach { color in
                
                clearColorPopUp.addItem(withTitle: color.name)
            }
            
            if let floorColor = meadow.world.floor.color, let index = ColorPalettes.shared?.allColors.index(of: floorColor) {
                
                clearColorPopUp.selectItem(at: index)
                
                clearColorPaletteView.color = floorColor
            }
            
        default: break
        }
    }
}
