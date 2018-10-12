//
//  WaterInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class WaterInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    
    @IBOutlet weak var chunkCount: NSTextField!
    @IBOutlet weak var tileCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    @IBOutlet weak var chunkHiddenButton: NSButton!
    @IBOutlet weak var tileHiddenButton: NSButton!
    @IBOutlet weak var nodeHiddenButton: NSButton!
    
    @IBOutlet weak var xTileCoordinateLabel: NSTextField!
    @IBOutlet weak var yTileCoordinateLabel: NSTextField!
    @IBOutlet weak var zTileCoordinateLabel: NSTextField!
    
    @IBOutlet weak var selectedNodePopUp: NSPopUpButton!
    
    @IBOutlet weak var sceneView: InspectorSceneView!
    
    @IBOutlet weak var xNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var yNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var zNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var widthNodeSizeLabel: NSTextField!
    @IBOutlet weak var heightNodeSizeLabel: NSTextField!
    @IBOutlet weak var depthNodeSizeLabel: NSTextField!
    
    @IBOutlet weak var selectedWaterTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .water(let editor, let inspectable):
            
            switch sender {
                
            case gridHiddenButton:
                
                inspectable.grid.isHidden = sender.state == .off
                
            case chunkHiddenButton:
                
                guard let chunk = inspectable.chunk else { break }
                
                chunk.isHidden = sender.state == .off
                
            case tileHiddenButton:
                
                guard let tile = inspectable.tile else { break }
                
                tile.isHidden = sender.state == .off
                
            case nodeHiddenButton:
                
                guard let node = inspectable.node else { break }
                
                node.isHidden = sender.state == .off
                
            default: break
            }
            
            viewModel.state = .water(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .water(let editor, let inspectable):
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let tile = inspectable.tile, let selectedNode = tile.child(at: sender.indexOfSelectedItem) as? WaterNode else { break }
                
                viewModel.state = .water(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, tile, selectedNode))
                
                editor.delegate.sceneGraph(didSelectChild: selectedNode, atIndex: sender.indexOfSelectedItem)
                
            case selectedWaterTypePopUp:
                
                guard let node = inspectable.node, let selectedWaterType = WaterType(rawValue: sender.indexOfSelectedItem) else { break }
                
                node.waterType = selectedWaterType
                
                viewModel.state = .water(editor: editor, inspectable: inspectable)
                
            default: break
            }
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return WaterInspectorViewModel(initialState: .empty)
    }()
}

extension WaterInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension WaterInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .water(_, let inspectable):
            
            chunkCount.integerValue = inspectable.grid.totalChildren
            gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
            
            chunkBox.isHidden = true
            tileBox.isHidden = true
            nodeBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            selectedWaterTypePopUp.removeAllItems()
            
            if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node {
                
                chunkBox.isHidden = inspectable.grid.isHidden
                tileBox.isHidden = inspectable.grid.isHidden || chunk.isHidden
                nodeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden
                
                tileCount.integerValue = chunk.totalChildren
                chunkHiddenButton.state = (chunk.isHidden ? .off : .on)
                tileHiddenButton.state = (tile.isHidden ? .off : .on)
                nodeHiddenButton.state = (node.isHidden ? .off : .on)
                
                xTileCoordinateLabel.integerValue = tile.volume.coordinate.x
                yTileCoordinateLabel.integerValue = tile.volume.coordinate.y
                zTileCoordinateLabel.integerValue = tile.volume.coordinate.z
                
                for index in 0..<tile.totalChildren {
                    
                    selectedNodePopUp.addItem(withTitle: "Node \(index + 1)")
                }
                
                if let index = tile.index(of: node) {
                    
                    selectedNodePopUp.selectItem(at: index)
                }
                
                xNodeCoordinateLabel.integerValue = node.volume.coordinate.x
                yNodeCoordinateLabel.integerValue = node.volume.coordinate.y
                zNodeCoordinateLabel.integerValue = node.volume.coordinate.z
                widthNodeSizeLabel.integerValue = node.volume.size.width
                heightNodeSizeLabel.integerValue = node.volume.size.height
                depthNodeSizeLabel.integerValue = node.volume.size.depth
                
                WaterType.allCases.forEach { waterType in
                    
                    selectedWaterTypePopUp.addItem(withTitle: waterType.name)
                }
                
                if let waterType = node.waterType, let index = WaterType.allCases.index(of: waterType), let colorPalette = waterType.colorPalette {
                    
                    selectedWaterTypePopUp.selectItem(at: index)
                    
                    colorPaletteView.colorPalette = colorPalette
                }
                else {
                    
                    colorPaletteView.colorPalette = nil
                }
            }
            
        default: break
        }
    }
}
