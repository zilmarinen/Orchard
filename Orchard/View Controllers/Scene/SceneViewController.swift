//
//  SceneViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit
import Terrace

class SceneViewController: NSViewController {

    @IBOutlet weak var _sceneView: SceneView!
    @IBOutlet weak var pathControl: NSPathControl!
    
    weak var coordinator: SceneViewCoordinator?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        do {
            
            guard let device = _sceneView.device else { fatalError("Invalid device for SceneView") }
            
            guard let path = Meadow.bundle?.path(forResource: "Meadow", ofType: "metallib") else { fatalError("Missing required Meadow.metallib") }
            
            Stage.shaderLibrary = try device.makeLibrary(filepath: path)
        }
        catch {
            
            fatalError("Unable to make Meadow.metallib default device program library: \(error)")
        }
    }
}
