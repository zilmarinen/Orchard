//
//  SceneGraphViewController.swift
//  Orchard
//
//  Created by Zack Brown on 12/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

protocol SceneGraphDelegate {
 
    func sceneGraph(outlineView: NSOutlineView, viewForItem item: Any, inColumn column: NSTableColumn?) -> NSView?
}

protocol SceneGraphDataSource {
    
    func sceneGraph(numberOfChildrenOfItem item: Any?) -> Int
    func sceneGraph(childOfItem item: Any?, atIndex index: Int) -> Any
}

class SceneGraphViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    var delegate: SceneGraphDelegate?
    var dataSource: SceneGraphDataSource?
}

extension SceneGraphViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        outlineView.register(NSNib(nibNamed: NSNib.Name(SceneGraphCell.cellIdentifier), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(SceneGraphCell.cellIdentifier))
    }
}

extension SceneGraphViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    
        guard let dataSource = dataSource else { return 0 }
        
        return dataSource.sceneGraph(numberOfChildrenOfItem: item)
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        guard let dataSource = dataSource else { return item! }
        
        return dataSource.sceneGraph(childOfItem: item, atIndex: index)
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        guard let dataSource = dataSource else { return false }
        
        return dataSource.sceneGraph(numberOfChildrenOfItem: item) != 0
    }
}

extension SceneGraphViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        guard let delegate = delegate else { return nil }
        
        return delegate.sceneGraph(outlineView: outlineView, viewForItem: item, inColumn: tableColumn)
    }
}
