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
    
    @IBOutlet weak var gridBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    
    @IBOutlet weak var buildButton: NSButton!
    @IBOutlet weak var paintButton: NSButton!
    @IBOutlet weak var terraformButton: NSButton!

    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        switch sender {
            
        case gridRenderingButton:
            
            inspectable.grid.isHidden = sender.state == .off
            
        case buildButton:
            
            print("build")
            
        case paintButton:
            
            print("paint")
            
        case terraformButton:
            
            print("terraform")
            
        default: break
        }
    }
    
    weak var coordinator: TerrainUtilityCoordinator?
    
    var tabViewController: TerrainUtilityTabViewController?
    
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

extension TerrainUtilityViewController {
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "embedTabView":
            
            guard let tabViewController = segue.destinationController as? TerrainUtilityTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
            
        default: break;
        }
    }
}

