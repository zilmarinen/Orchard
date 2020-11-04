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
        
        let panel = sender.selectedSegment == 0 ? SplitViewController.Panel.sceneGraph : SplitViewController.Panel.inspector
        
        coordinator?.toggle(panel: panel)
    }
}
