//
//  OrchardWindowController.swift
//  Orchard
//
//  Created by Zack Brown on 12/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class OrchardWindowController: NSWindowController {

    @IBAction func segmentedControl(_ sender: Any) {
        
        guard let sender = sender as? NSSegmentedControl, let orchardViewController = contentViewController as? OrchardViewController, let splitViewController = orchardViewController.splitViewController else { return }
        
        let panel = (sender.selectedSegment == 0 ? SplitViewController.Panel.sceneGraph : SplitViewController.Panel.utilities)
        
        splitViewController.toggle(panel: panel)
    }
}
