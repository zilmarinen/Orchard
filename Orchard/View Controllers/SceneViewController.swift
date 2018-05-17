//
//  SceneViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class SceneViewController: NSViewController {

    @IBOutlet weak var sceneView: SCNView!
    
    var meadow: Meadow!

    var delegate: GridDelegate?
}

extension SceneViewController {
    
    override func awakeFromNib() {
        
        self.meadow = Meadow(delegate: self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sceneView.scene = meadow
        sceneView.delegate = meadow
        sceneView.showsStatistics = true
        
        let node = meadow.terrain.add(node: Coordinate.Zero)
        let _ = meadow.terrain.add(node: Coordinate.One)
        
        if let terrainType = meadow.terrain.find(terrainType: "Grass") {
        
            let _ = node?.add(layer: terrainType)
        }
    }
}

extension SceneViewController: GridDelegate {
    
    func didBecomeDirty(node: GridNode) {
        
        delegate?.didBecomeDirty(node: node)
    }
}
