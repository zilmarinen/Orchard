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
        
        guard let meadow = meadow else { return }
        
        meadow.rootNode.name = textField.stringValue
    }
    
    var meadow: Meadow? {
    
        didSet {
            
            if let meadow = meadow {
                
                nameTextField.stringValue = meadow.rootNode.name ?? ""
            }
            else {
                
                nameTextField.stringValue = ""
            }
        }
    }
}
