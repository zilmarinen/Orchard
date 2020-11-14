//
//  WindowController.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class WindowController: NSWindowController {
    
    var splitViewController: SplitViewController? { contentViewController as? SplitViewController }
    
    weak var coordinator: WindowCoordinator?
    
    @IBAction func segmentedControl(_ sender: NSSegmentedControl) {
        
        coordinator?.toggle(splitView: (sender.selectedSegment == 0 ? .sceneGraph : .sidebar))
    }
}
