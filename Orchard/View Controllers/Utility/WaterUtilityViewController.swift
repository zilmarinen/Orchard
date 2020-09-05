//
//  WaterUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import AppKit

class WaterUtilityViewController: NSViewController, Inspector {
    
    @IBOutlet weak var gridBox: NSBox!
    
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
    
    var inspector: WaterInspector? {
        
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

extension WaterUtilityViewController {

    func update() {
    
        guard let inspectable = inspector?.inspectable else { return }
        
        self.chunkCountLabel.integerValue = inspectable.grid.childCount
        self.gridRenderingButton.state = (inspectable.grid.isHidden ? .off : .on)
    }
}

