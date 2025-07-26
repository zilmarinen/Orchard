//
//  EditorToolbarController.swift
//  Core
//
//  Created by Zack Brown on 12/07/2025.
//

import AppKit
import Base

internal class EditorToolbarController: NSViewController {
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let label = NSTextField(labelWithString: "Editor Toolbar")
        
        view.addSubview(label)
        
        label.center(in: view)
    }
}
