//
//  TerrainInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import AppKit

class TerrainInspectorViewController: NSViewController, Inspector {
    
    @IBOutlet weak var terrainBox: NSBox!
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var edgeBox: NSBox!
    @IBOutlet weak var layerBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var tileCountLabel: NSTextField!
    @IBOutlet weak var edgeCountLabel: NSTextField!
    @IBOutlet weak var layerCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var chunkRenderingButton: NSButton!
    @IBOutlet weak var tileRenderingButton: NSButton!
    @IBOutlet weak var edgeRenderingButton: NSButton!
    @IBOutlet weak var layerRenderingButton: NSButton!
    
    @IBOutlet weak var edgePopUp: NSPopUpButton!
    @IBOutlet weak var layerPopUp: NSPopUpButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        switch sender {
            
        case gridRenderingButton:
            
            inspectable.grid.isHidden = sender.state == .off
            
        case chunkRenderingButton:
            
            guard let chunk = inspectable.chunk else { return }
            
            chunk.isHidden = sender.state == .off
        
        case tileRenderingButton:
            
            guard let tile = inspectable.tile else { return }
            
            tile.isHidden = sender.state == .off
            
        case edgeRenderingButton:
            
            guard let edge = inspectable.edge else { return }
            
            edge.isHidden = sender.state == .off
            
        case layerRenderingButton:
            
            guard let layer = inspectable.layer else { return }
            
            layer.isHidden = sender.state == .off
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
    }
    
    var inspector: TerrainInspector? {
        
        didSet {
            
            guard self.isViewLoaded else { return }
            
            update()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        update()
    }
}

extension TerrainInspectorViewController {
    
    func update() {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        self.chunkBox.isHidden = inspectable.chunk == nil
        self.tileBox.isHidden = inspectable.tile == nil
        self.edgeBox.isHidden = inspectable.edge == nil
        self.layerBox.isHidden = inspectable.layer == nil
        
        self.chunkCountLabel.integerValue = inspectable.grid.childCount
        self.gridRenderingButton.state = (inspectable.grid.isHidden ? .off : .on)
        
        guard let chunk = inspectable.chunk else { return }
        
        self.tileCountLabel.integerValue = chunk.childCount
        self.chunkRenderingButton.state = (chunk.isHidden ? .off : .on)
        
        guard let tile = inspectable.tile else { return }
        
        self.edgeCountLabel.integerValue = tile.childCount
        self.tileRenderingButton.state = (tile.isHidden ? .off : .on)
        
        self.edgePopUp.removeAllItems()
        
        for child in tile.children {
            
            guard let edge = child as? TerrainEdge else { continue }
            
            self.edgePopUp.addItem(withTitle: edge.cardinal.description)
        }
        
        guard let edge = inspectable.edge else { return }
        
        self.layerCountLabel.integerValue = edge.childCount
        self.edgeRenderingButton.state = (edge.isHidden ? .off : .on)
        
        guard let layer = inspectable.layer else { return }
        
        self.layerRenderingButton.state = (layer.isHidden ? .off : .on)
    }
}
