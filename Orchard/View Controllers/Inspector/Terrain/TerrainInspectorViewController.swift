//
//  TerrainInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class TerrainInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkCount: NSTextField!
    @IBOutlet weak var terrainTypeCount: NSTextField!
    
    @IBOutlet weak var selectedLayerPopUp: NSPopUpButton!
    
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var layerBox: NSBox!
    
    var inspectable: (terrain: Terrain, layer: TerrainLayer?)? {
        
        didSet {
            
            guard let inspectable = inspectable else { return }
            
            chunkCount.stringValue = "\(inspectable.terrain.totalChildren)"
            terrainTypeCount.stringValue = "\(inspectable.terrain.availableTerrainTypes.count)"
            
            selectedLayerPopUp.removeAllItems()
            
            nodeBox.isHidden = true
            layerBox.isHidden = true
            
            if let layer = inspectable.layer {
            
                nodeBox.isHidden = false
                layerBox.isHidden = false
                
                for index in 0..<layer.node.totalChildren {
                    
                    selectedLayerPopUp.addItem(withTitle: "Layer \(index)")
                }
            }
        }
    }
}
