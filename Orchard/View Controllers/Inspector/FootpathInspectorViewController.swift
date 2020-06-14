//
//  FootpathInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import AppKit

class FootpathInspectorViewController: NSViewController, Inspector {
    
    weak var coordinator: FootpathInspectorCoordinator?

    var inspector: FootpathInspector? {
            
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

extension FootpathInspectorViewController {
    
    func update() {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        //
    }
}
