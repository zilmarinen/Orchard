//
//  AreaArchitectureUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class AreaArchitectureUtilitiesViewController: NSViewController {
    
    lazy var stateObserver = {
        
        return AreaArchitectureUtilitiesStateObserver(initialState: .empty(editor: nil))
    }()
}

extension AreaArchitectureUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension AreaArchitectureUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
        
            switch to {
            
            default: break
            }
        }
    }
}
