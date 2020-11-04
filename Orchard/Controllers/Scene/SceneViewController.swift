//
//  SceneViewController.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import SceneKit

class SceneViewController: NSViewController {
    
    @IBOutlet weak var pathControl: NSPathControl!
    @IBOutlet weak var sceneView: SCNView!
    
    weak var coordinator: SceneCoordinator?
}
