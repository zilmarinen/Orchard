//
//  AreaInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import AppKit

class AreaInspectorViewController: NSViewController, Inspector {
    
    weak var coordinator: AreaInspectorCoordinator?

    var inspector: AreaInspector? {
            
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

extension AreaInspectorViewController {
    
    func update() {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        //
    }
}
