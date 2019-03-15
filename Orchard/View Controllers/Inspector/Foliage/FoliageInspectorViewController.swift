//
//  FoliageInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class FoliageInspectorViewController: NSViewController {
    
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
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .foliage(let editor, let inspectable):
            
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
            
            viewModel.state = .foliage(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .foliage(let editor, let inspectable):
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let tile = inspectable.tile, let selectedNode = tile.child(at: sender.indexOfSelectedItem) as? FoliageNode else { break }
                
                viewModel.state = .foliage(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, tile, selectedNode))
                
                editor.delegate.sceneGraph(didSelectChild: selectedNode, atIndex: sender.indexOfSelectedItem)
                
            default: break
            }
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return FoliageInspectorViewModel(initialState: .empty)
    }()
}

extension FoliageInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension FoliageInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .foliage(_, let inspectable):
                
                self.chunkCount.integerValue = inspectable.grid.totalChildren
                self.gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
                
                self.chunkBox.isHidden = true
                self.tileBox.isHidden = true
                self.nodeBox.isHidden = true
                
                self.selectedNodePopUp.removeAllItems()
                
                if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node {
                    
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
