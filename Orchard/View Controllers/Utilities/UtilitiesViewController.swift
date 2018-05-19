//
//  UtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 17/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import THRUtilities

class UtilitiesViewController: NSViewController {
    
    @IBOutlet weak var area: NSButton!
    @IBOutlet weak var foliage: NSButton!
    @IBOutlet weak var footpath: NSButton!
    @IBOutlet weak var terrain: NSButton!
    @IBOutlet weak var water: NSButton!
    
    var tabViewController: TabViewController?
    
    @IBAction func button(_ sender: Any) {
        
        guard let sender = sender as? NSButton, let tabViewController = tabViewController else { return }
        
        switch sender {
            
        case area:
            
            tabViewController.toggle(panel: .area)
            
        case foliage:
            
            tabViewController.toggle(panel: .foliage)
            
        case footpath:
            
            tabViewController.toggle(panel: .footpath)
            
        case terrain:
            
            tabViewController.toggle(panel: .terrain)
            
        case water:
            
            tabViewController.toggle(panel: .water)
            
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
            
            guard let tabViewController = segue.destinationController as? TabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}
