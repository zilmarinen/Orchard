//
//  InspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 17/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import THRUtilities

class InspectorViewController: NSViewController {
    
    @IBOutlet weak var area: NSButton!
    @IBOutlet weak var foliage: NSButton!
    @IBOutlet weak var footpath: NSButton!
    @IBOutlet weak var terrain: NSButton!
    @IBOutlet weak var water: NSButton!
    
    var tabViewController: InspectorTabViewController?
    
    @IBAction func button(_ sender: Any) {
        
        guard let sender = sender as? NSButton, let tabViewController = tabViewController else { return }
        
        switch sender {
            
        case area:
            
            tabViewController.viewModel.state = .area
            
        case foliage:
            
            tabViewController.viewModel.state = .foliage
            
        case footpath:
            
            tabViewController.viewModel.state = .footpath
            
        case terrain:
            
            tabViewController.viewModel.state = .terrain
            
        case water:
            
            tabViewController.viewModel.state = .water
            
        default: break
        }
    }
}

extension InspectorViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? InspectorTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}
