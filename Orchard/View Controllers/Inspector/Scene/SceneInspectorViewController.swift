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
            
        case .scene(let editor):
            
            let selectedColor = ColorPalettes.shared?.allColors[sender.indexOfSelectedItem]
            
            editor.meadow.world.floor.color = selectedColor
            
            viewModel.state = .scene(editor: editor)
            
        default: break
        }
    }
    
    @IBAction func textField(_ textField: NSTextField) {
        
        switch viewModel.state {
            
        case .scene(let editor):
            
            editor.meadow.rootNode.name = textField.stringValue
            
            viewModel.state = .scene(editor: editor)
            
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
            
        case .scene(let editor):
            
            clearColorPopUp.removeAllItems()
            
            nameTextField.stringValue = editor.meadow.rootNode.name ?? ""
            
            ColorPalettes.shared?.allColors.forEach { color in
                
                clearColorPopUp.addItem(withTitle: color.name)
            }
            
            if let floorColor = editor.meadow.world.floor.color, let index = ColorPalettes.shared?.allColors.index(of: floorColor) {
                
                clearColorPopUp.selectItem(at: index)
                
                clearColorPaletteView.color = floorColor
            }
            
        default: break
        }
    }
}
