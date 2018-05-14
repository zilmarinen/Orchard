//
//  OrchardViewController.swift
//  Orchard
//
//  Created by Zack Brown on 12/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit
import THRUtilities

class OrchardViewController: NSViewController {
    
    var sceneGraphViewController: SceneGraphViewController?
    var sceneViewController: SceneViewController?
}

extension OrchardViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedSplitView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedSplitView:
            
            guard let splitViewController = segue.destinationController as? NSSplitViewController else { fatalError("Invalid segue destination") }
            
            self.sceneGraphViewController = splitViewController.childViewControllers.first { return type(of: $0) == SceneGraphViewController.self } as? SceneGraphViewController
            self.sceneViewController = splitViewController.childViewControllers.first { return type(of: $0) == SceneViewController.self } as? SceneViewController
            
            guard let sceneGraphViewController = sceneGraphViewController, let sceneViewController = sceneViewController else { fatalError("Invalid SplitViewController children") }
            
            sceneGraphViewController.dataSource = self
            sceneGraphViewController.delegate = self
            
            sceneViewController.delegate = self
        }
    }
}

extension OrchardViewController: SceneGraphDataSource {
    
    func sceneGraph(numberOfChildrenOfItem item: Any?) -> Int {
        
        if let item = item as? SceneGraphNode {
            
            return item.totalChildren
        }
        
        guard let meadow = sceneViewController?.meadow else { return 0 }
        
        return meadow.rootNode.childNodes.count
    }
    
    func sceneGraph(childOfItem item: Any?, atIndex index: Int) -> Any {
        
        if let item = item as? SceneGraphNode {
            
            if let child = item.sceneGraph(childAtIndex: index) {
                
                return child
            }
        }
        
        guard let meadow = sceneViewController?.meadow else { return item! }
        
        return meadow.rootNode.childNodes[index]
    }
}

extension OrchardViewController: SceneGraphDelegate {
    
    func sceneGraph(outlineView: NSOutlineView, viewForItem item: Any, inColumn column: NSTableColumn?) -> NSView? {
        
        guard let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("sceneGraphCell"), owner: self) as? NSTableCellView else { return nil }
        
        if let item = item as? SceneGraphNode {
        
            view.textField?.stringValue = item.nodeName
        }
        
        return view
    }
}

extension OrchardViewController: GridDelegate {
    
    func didBecomeDirty(node: GridNode) {
        
        guard let sceneGraphViewController = sceneGraphViewController else { return }
        
        sceneGraphViewController.outlineView.reloadData()
    }
}
