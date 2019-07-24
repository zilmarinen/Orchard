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
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                let selectedColor = ArtDirector.shared?.colors.children[sender.indexOfSelectedItem]
                
                world.floor.color = selectedColor
                
                viewModel.state = .scene(editor: editor)
                
            default: break
            }
            
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
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .scene(let editor):
                
                switch editor.meadow.scene.model.state {
                    
                case .scene(let world):
                    
                    self.clearColorPopUp.removeAllItems()
                    
                    self.nameTextField.stringValue = editor.meadow.scene.rootNode.name ?? ""
                    
                    if let colorCount = ArtDirector.shared?.colors.children.count {
                        
                        for index in 0..<colorCount {
                            
                            if let color = ArtDirector.shared?.colors.children[index] {
                                
                                self.clearColorPopUp.addItem(withTitle: color.name)
                                
                                self.clearColorPopUp.lastItem?.set(color: color.color)
                            }
                        }
                    }
                    
                    if let floorColor = world.floor.color, let index = ArtDirector.shared?.colors.children.index(of: floorColor) {
                        
                        self.clearColorPopUp.selectItem(at: index)
                        
                        self.clearColorPaletteView.color = floorColor
                    }
                    
                default: break
                }
                
            default: break
            }
        }
    }
}
