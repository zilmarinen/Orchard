//
//  MeadowInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 24/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import AppKit

class MeadowInspectorViewController: NSViewController, Inspector {
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var colorWell: NSColorWell!
    
    @IBAction func colorWell(_ sender: NSColorWell) {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        inspectable.floor.backgroundColor = colorWell.color
    }
    
    var inspector: MeadowInspector? {
        
        didSet {
            
            guard self.isViewLoaded else { return }
            
            update()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        update()
    }
}

extension MeadowInspectorViewController {
    
    func update() {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        nameTextField.stringValue = inspectable.name ?? ""
        
        colorWell.color = inspectable.floor.backgroundColor
    }
}
