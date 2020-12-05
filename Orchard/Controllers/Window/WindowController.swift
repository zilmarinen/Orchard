//
//  WindowController.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow

class WindowController: NSWindowController {
    
    var splitViewController: SplitViewController? { contentViewController as? SplitViewController }
    
    weak var coordinator: WindowCoordinator?
    
    @IBOutlet weak var seasonPopUp: NSPopUpButton! {
        
        didSet {
            
            seasonPopUp.removeAllItems()
            
            for season in Season.allCases {
                
                seasonPopUp.addItem(withTitle: season.description)
            }
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        coordinator?.toggle(season: sender.indexOfSelectedItem)
    }
    
    @IBAction func segmentedControl(_ sender: NSSegmentedControl) {
        
        coordinator?.toggle(splitView: (sender.selectedSegment == 0 ? .sceneGraph : .sidebar))
    }
}
