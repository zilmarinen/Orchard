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
            
            let selectedColor = ArtDirector.shared?.colors.children[sender.indexOfSelectedItem]
            
            editor.meadow.scene.world.floor.color = selectedColor
            
            viewModel.state = .scene(editor: editor)
            
        default: break
        }
    }
    
    @IBAction func textField(_ textField: NSTextField) {
        
        switch viewModel.state {
            
        case .scene(let editor):
            
            editor.meadow.scene.rootNode.name = textField.stringValue
            
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
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension SceneInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .scene(let editor):
            
            clearColorPopUp.removeAllItems()
            
            nameTextField.stringValue = editor.meadow.scene.rootNode.name ?? ""
            
            if let colorCount = ArtDirector.shared?.colors.children.count {
                
                for index in 0..<colorCount {
                    
                    if let color = ArtDirector.shared?.colors.children[index] {
                        
                        clearColorPopUp.addItem(withTitle: color.name)
                        
                        clearColorPopUp.lastItem?.set(color: color.color)
                    }
                }
            }
            
            if let floorColor = editor.meadow.scene.world.floor.color, let index = ArtDirector.shared?.colors.children.index(of: floorColor) {
                
                clearColorPopUp.selectItem(at: index)
                
                clearColorPaletteView.color = floorColor
            }
            
        default: break
        }
    }
}
