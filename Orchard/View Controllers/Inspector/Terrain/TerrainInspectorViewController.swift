//
//  TerrainInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class TerrainInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkCount: NSTextField!
    
    @IBOutlet weak var xNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var yNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var zNodeCoordinateLabel: NSTextField!
    
    @IBOutlet weak var selectedLayerPopUp: NSPopUpButton!
    
    @IBOutlet weak var layerNorthEdgeTerrainTypePopUp: NSPopUpButton!
    @IBOutlet weak var layerEastEdgeTerrainTypePopUp: NSPopUpButton!
    @IBOutlet weak var layerSouthEdgeTerrainTypePopUp: NSPopUpButton!
    @IBOutlet weak var layerWestEdgeTerrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var layerNorthWestCornerLabel: NSTextField!
    @IBOutlet weak var layerNorthEastCornerLabel: NSTextField!
    @IBOutlet weak var layerSouthEastCornerLabel: NSTextField!
    @IBOutlet weak var layerSouthWestCornerLabel: NSTextField!
    
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var layerBox: NSBox!
    
    @IBOutlet weak var sceneView: SCNView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let terrain, let layer):
            
            guard let layer = layer else { break }
            
            switch sender {
                
            case selectedLayerPopUp:
             
                let selectedLayer = layer.node.sceneGraph(childAtIndex: selectedLayerPopUp.indexOfSelectedItem) as? TerrainLayer
                
                viewModel.state = .inspecting(terrain, selectedLayer)
                
            case layerNorthEdgeTerrainTypePopUp,
                 layerEastEdgeTerrainTypePopUp,
                 layerSouthEdgeTerrainTypePopUp,
                 layerWestEdgeTerrainTypePopUp:
                
                let terrainType = terrain.availableTerrainTypes[sender.indexOfSelectedItem]
                
                switch sender {
                    
                case layerNorthEdgeTerrainTypePopUp: layer.set(terrainType: terrainType, edge: .north)
                case layerEastEdgeTerrainTypePopUp: layer.set(terrainType: terrainType, edge: .east)
                case layerSouthEdgeTerrainTypePopUp: layer.set(terrainType: terrainType, edge: .south)
                case layerWestEdgeTerrainTypePopUp: layer.set(terrainType: terrainType, edge: .west)
                default: break
                }
                
                viewModel.state = .inspecting(terrain, layer)
                
            default: break
            }
        
        default: break
        }
    }
    
    @IBAction func textField(_ sender: NSTextField) {
        
        switch viewModel.state {
            
        case .inspecting(let terrain, let layer):
            
            guard let layer = layer else { break }
            
            switch sender {
                
            case layerNorthWestCornerLabel:
                
                layer.set(height: layerNorthWestCornerLabel.integerValue, corner: .northWest)
                
            case layerNorthEastCornerLabel:
                
                layer.set(height: layerNorthEastCornerLabel.integerValue, corner: .northEast)
                
            case layerSouthEastCornerLabel:
                
                layer.set(height: layerSouthEastCornerLabel.integerValue, corner: .southEast)
                
            case layerSouthWestCornerLabel:
                
                layer.set(height: layerSouthWestCornerLabel.integerValue, corner: .southWest)
                
            default: break
            }
            
            viewModel.state = .inspecting(terrain, layer)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainInspectorViewModel(initialState: .empty)
    }()
}

extension TerrainInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension TerrainInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let terrain, let layer):
            
            chunkCount.stringValue = "\(terrain.totalChildren)"
            
            selectedLayerPopUp.removeAllItems()
            layerNorthEdgeTerrainTypePopUp.removeAllItems()
            layerEastEdgeTerrainTypePopUp.removeAllItems()
            layerSouthEdgeTerrainTypePopUp.removeAllItems()
            layerWestEdgeTerrainTypePopUp.removeAllItems()
            
            nodeBox.isHidden = true
            layerBox.isHidden = true
            
            guard let layer = layer else { break }
                
            nodeBox.isHidden = false
            layerBox.isHidden = false
            
            for index in 0..<layer.node.totalChildren {
                
                selectedLayerPopUp.addItem(withTitle: "Layer \(index)")
            }
            
            terrain.availableTerrainTypes.forEach { terrainType in
                
                layerNorthEdgeTerrainTypePopUp.addItem(withTitle: terrainType.name)
                layerEastEdgeTerrainTypePopUp.addItem(withTitle: terrainType.name)
                layerSouthEdgeTerrainTypePopUp.addItem(withTitle: terrainType.name)
                layerWestEdgeTerrainTypePopUp.addItem(withTitle: terrainType.name)
            }
            
            selectedLayerPopUp.selectItem(at: layer.node.index(of: layer)!)
            xNodeCoordinateLabel.stringValue = "\(layer.node.volume.coordinate.x)"
            yNodeCoordinateLabel.stringValue = "\(layer.node.volume.coordinate.y)"
            zNodeCoordinateLabel.stringValue = "\(layer.node.volume.coordinate.z)"
            
            layerNorthEdgeTerrainTypePopUp.selectItem(at: terrain.availableTerrainTypes.index(of: layer.get(terrainType: .north)!.terrainType)!)
            layerEastEdgeTerrainTypePopUp.selectItem(at: terrain.availableTerrainTypes.index(of: layer.get(terrainType: .east)!.terrainType)!)
            layerSouthEdgeTerrainTypePopUp.selectItem(at: terrain.availableTerrainTypes.index(of: layer.get(terrainType: .south)!.terrainType)!)
            layerWestEdgeTerrainTypePopUp.selectItem(at: terrain.availableTerrainTypes.index(of: layer.get(terrainType: .west)!.terrainType)!)
            layerNorthWestCornerLabel.stringValue = "\(layer.get(height: .northWest))"
            layerNorthEastCornerLabel.stringValue = "\(layer.get(height: .northEast))"
            layerSouthEastCornerLabel.stringValue = "\(layer.get(height: .southEast))"
            layerSouthWestCornerLabel.stringValue = "\(layer.get(height: .southWest))"
            
        default: break
        }
    }
}
