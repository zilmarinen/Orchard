//
//  UtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import THRUtilities

class UtilitiesViewController: NSViewController {

    var tabViewController: UtilitiesTabViewController?
    
    @IBOutlet weak var areaButton: NSButton!
    @IBOutlet weak var foliageButton: NSButton!
    @IBOutlet weak var footpathButton: NSButton!
    @IBOutlet weak var terrainButton: NSButton!
    @IBOutlet weak var waterButton: NSButton!
    
    @IBAction func button(_ sender: Any) {
        
        guard let tabViewController = tabViewController else { return }
        
        switch sender as! NSButton {
            
        case areaButton:
            
            tabViewController.viewModel.state = .area
            
        case foliageButton:
            
            tabViewController.viewModel.state = .foliage
            
        case footpathButton:
            
            tabViewController.viewModel.state = .footpath
            
        case terrainButton:
            
            tabViewController.viewModel.state = .terrain
            
        case waterButton:
            
            tabViewController.viewModel.state = .water
            
        default: break
        }
    }
}

extension UtilitiesViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? UtilitiesTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}
