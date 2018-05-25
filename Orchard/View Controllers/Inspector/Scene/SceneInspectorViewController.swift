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
            
            nameTextField.stringValue = meadow.rootNode.name ?? ""
            
        default: break
        }
    }
}
