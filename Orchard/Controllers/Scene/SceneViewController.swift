//
//  SceneViewController.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow
import SceneKit
import SpriteKit

class SceneViewController: NSViewController {
    
    @IBOutlet weak var skView: SpriteView!
    @IBOutlet weak var scnView: SceneView!
    
    weak var coordinator: SceneCoordinator?
}
