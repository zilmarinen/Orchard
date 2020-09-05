//
//  TerrainUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import AppKit

class TerrainUtilityViewController: NSViewController {
    
    lazy var viewModel: ViewModel = {
        
        return ViewModel(initialState: .empty)
    }()
    
    weak var coordinator: TerrainUtilityCoordinator?
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var buildBox: NSBox!
    @IBOutlet weak var paintBox: NSBox!
    @IBOutlet weak var terraformBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    
    //
    /// Build
    //
    
    @IBOutlet weak var buildToolTypePopUp: NSPopUpButton!
    @IBOutlet weak var buildTerrainTypePopUp: NSPopUpButton!
    
    //
    /// Paint
    //
    
    @IBOutlet weak var paintToolTypePopUp: NSPopUpButton!
    @IBOutlet weak var paintTerrainTypePopUp: NSPopUpButton!
    
    //
    /// Terraform
    //
     
    @IBAction func button(_ sender: NSButton) {
        
        switch sender {
            
        case gridRenderingButton:
            
            print("")
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case buildToolTypePopUp:
            
            print("")
            
        default: break
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainUtilityViewController {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
    
        DispatchQueue.main.async {
            
            //
        }
    }
}
