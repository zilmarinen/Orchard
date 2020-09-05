//
//  AreaInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import AppKit

class AreaInspectorViewController: NSViewController, Inspector {
    
    weak var coordinator: AreaInspectorCoordinator?
    
    @IBOutlet weak var gridBox: NSBox!
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
        
        guard let inspectable = inspector?.inspectable else { return }
        
        switch sender {
            
        case edgePopUp:
            
            guard let tile = inspectable.tile, let edge = tile.find(edge: tile.joints[sender.indexOfSelectedItem]) else { return }
            
            self.coordinator?.didSelect(node: edge)
            
        case layerPopUp:
            
            guard let edge = inspectable.edge, let layer = edge.find(layer: sender.indexOfSelectedItem) else { return }
            
            self.coordinator?.didSelect(node: layer)
            
        default: break
        }
    }
    
    var inspector: AreaInspector? {
            
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

extension AreaInspectorViewController {
    
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
        
        self.edgePopUp.removeAllItems()
        
        for identifier in tile.joints {
            
            self.edgePopUp.addItem(withTitle: "\(identifier)")
        }
        
        guard let edge = inspectable.edge else { return }
        
        self.edgePopUp.selectItem(withTitle: "\(edge.identifier)")
        
        self.layerCountLabel.integerValue = edge.childCount
        self.edgeRenderingButton.state = (edge.isHidden ? .off : .on)
        
        self.layerPopUp.removeAllItems()
        
        for index in 0..<edge.childCount {
            
            self.layerPopUp.addItem(withTitle: "Layer \(index)")
        }
        
        guard let layer = inspectable.layer else { return }
        
        self.layerPopUp.selectItem(at: edge.index(of: layer) ?? 0)
        
        self.layerRenderingButton.state = (layer.isHidden ? .off : .on)
    }
}
