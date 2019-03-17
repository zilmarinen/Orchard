//
//  AreaInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class AreaInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    
    @IBOutlet weak var chunkCount: NSTextField!
    @IBOutlet weak var tileCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    @IBOutlet weak var chunkHiddenButton: NSButton!
    @IBOutlet weak var tileHiddenButton: NSButton!
    @IBOutlet weak var nodeHiddenButton: NSButton!
    
    @IBOutlet weak var gridWallRenderStateButton: NSButton!
    @IBOutlet weak var chunkWallRenderStateButton: NSButton!
    
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
    
    @IBOutlet weak var selectedExternalAreaTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedInternalAreaTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var selectedFloorColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var floorColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var selectedEdgePopup: NSPopUpButton!
    @IBOutlet weak var selectedEdgeTypePopup: NSPopUpButton!
    @IBOutlet weak var selectedArchitectureTypePopup: NSPopUpButton!
    
    @IBOutlet weak var externalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var externalColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var internalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var internalColorPaletteView: ColorPaletteView!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .area(let editor, let inspectable):
            
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
                
            case gridWallRenderStateButton:
                
                inspectable.grid.wallRenderState = (sender.state == .off ? .cutaway : .raised)
                
            case chunkWallRenderStateButton:
                
                guard let chunk = inspectable.chunk else { break }
                
                chunk.wallRenderState = (sender.state == .off ? .cutaway : .raised)
                
            default: break
            }
            
            viewModel.state = .area(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .area(let editor, let inspectable):
            
            switch sender {
                
            default: break
            }
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return AreaInspectorViewModel(initialState: .empty)
    }()
}

extension AreaInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension AreaInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
    
        DispatchQueue.main.async {
        
            switch to {
            
            case .area(_, let inspectable):
                
                self.chunkCount.integerValue = inspectable.grid.totalChildren
                self.gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
                
                self.gridWallRenderStateButton.state = (inspectable.grid.wallRenderState == .cutaway ? .off : .on)
                self.chunkWallRenderStateButton.state = .off
                
                self.chunkBox.isHidden = true
                self.tileBox.isHidden = true
                self.nodeBox.isHidden = true
                
                self.selectedNodePopUp.removeAllItems()
                self.selectedExternalAreaTypePopUp.removeAllItems()
                self.selectedInternalAreaTypePopUp.removeAllItems()
                self.selectedFloorColorPalettePopUp.removeAllItems()
                self.selectedEdgePopup.removeAllItems()
                self.selectedEdgeTypePopup.removeAllItems()
                self.selectedArchitectureTypePopup.removeAllItems()
                self.externalColorPalettePopup.removeAllItems()
                self.internalColorPalettePopup.removeAllItems()
                
                self.externalColorPalettePopup.isEnabled = false
                self.internalColorPalettePopup.isEnabled = false
                
                if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node {
                    
                    self.chunkWallRenderStateButton.state = (chunk.wallRenderState == .cutaway ? .off : .on)
                    
                    self.chunkBox.isHidden = inspectable.grid.isHidden
                    self.tileBox.isHidden = inspectable.grid.isHidden || chunk.isHidden
                    self.nodeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden
                    
                    self.tileCount.integerValue = chunk.totalChildren
                    self.chunkHiddenButton.state = (chunk.isHidden ? .off : .on)
                    self.tileHiddenButton.state = (tile.isHidden ? .off : .on)
                    self.nodeHiddenButton.state = (node.isHidden ? .off : .on)
                    
                    self.xTileCoordinateLabel.integerValue = tile.volume.coordinate.x
                    self.yTileCoordinateLabel.integerValue = tile.volume.coordinate.y
                    self.zTileCoordinateLabel.integerValue = tile.volume.coordinate.z
                    
                    for index in 0..<tile.totalChildren {
                        
                        self.selectedNodePopUp.addItem(withTitle: "Node \(index + 1)")
                    }
                    
                    if let index = tile.index(of: node) {
                     
                        self.selectedNodePopUp.selectItem(at: index)
                    }
                    
                    self.xNodeCoordinateLabel.integerValue = node.volume.coordinate.x
                    self.yNodeCoordinateLabel.integerValue = node.volume.coordinate.y
                    self.zNodeCoordinateLabel.integerValue = node.volume.coordinate.z
                    self.widthNodeSizeLabel.integerValue = node.volume.size.width
                    self.heightNodeSizeLabel.integerValue = node.volume.size.height
                    self.depthNodeSizeLabel.integerValue = node.volume.size.depth
                }
                
            default: break
            }
        }
    }
}
