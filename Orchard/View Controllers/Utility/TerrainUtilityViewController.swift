//
//  TerrainUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import AppKit

class TerrainUtilityViewController: NSViewController, Inspector {
    
    @IBOutlet weak var terrainBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!

    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        switch sender {
            
        case gridRenderingButton:
            
            inspectable.grid.isHidden = sender.state == .off
            
        default: break
        }
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

extension TerrainUtilityViewController {

    func update() {
    
        guard let inspectable = inspector?.inspectable else { return }
        
        self.chunkCountLabel.integerValue = inspectable.grid.childCount
        self.gridRenderingButton.state = (inspectable.grid.isHidden ? .off : .on)
    }
}
