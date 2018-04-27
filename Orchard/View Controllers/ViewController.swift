//
//  ViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class ViewController: NSViewController {

    @IBOutlet weak var sceneView: SCNView!
    
    let meadow = Meadow()
}

extension ViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sceneView.scene = meadow
    }
}
