//
//  FootpathInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import AppKit

class FootpathInspectorViewController: NSViewController, Inspector {
    
    weak var coordinator: FootpathInspectorCoordinator?
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var tileCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var chunkRenderingButton: NSButton!
    @IBOutlet weak var tileRenderingButton: NSButton!
    
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
            
        default: break
        }
    }

    var inspector: FootpathInspector? {
            
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

extension FootpathInspectorViewController {
    
    func update() {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        self.chunkBox.isHidden = inspectable.chunk == nil
        self.tileBox.isHidden = inspectable.tile == nil
        
        self.chunkCountLabel.integerValue = inspectable.grid.childCount
        self.gridRenderingButton.state = (inspectable.grid.isHidden ? .off : .on)
        
        guard let chunk = inspectable.chunk else { return }
        
        self.tileCountLabel.integerValue = chunk.childCount
        self.chunkRenderingButton.state = (chunk.isHidden ? .off : .on)
        
        guard let tile = inspectable.tile else { return }
        
        self.tileRenderingButton.state = (tile.isHidden ? .off : .on)
    }
}
