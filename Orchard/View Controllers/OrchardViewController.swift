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
    
    var splitViewController: SplitViewController?
}

extension OrchardViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedSplitView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedSplitView:
            
            guard let splitViewController = segue.destinationController as? SplitViewController else { fatalError("Invalid segue destination") }
            
            self.splitViewController = splitViewController
            
            if let sceneGraphViewController = splitViewController.sceneGraphViewController {
            
                sceneGraphViewController.dataSource = self
                sceneGraphViewController.delegate = self
            }
            
            if let sceneViewController = splitViewController.sceneViewController {
             
                sceneViewController.delegate = self
            }
        }
    }
}

extension OrchardViewController: SceneGraphDataSource {
    
    func sceneGraph(numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil {
            
            return 1
        }
        if let item = item as? SceneGraphNode {
            
            return item.totalChildren
        }
        else if let _ = item as? CameraJib {
            
            return 0
        }
        
        guard let sceneViewController = splitViewController?.sceneViewController, let meadow = sceneViewController.meadow else { return 0 }
        
        return meadow.rootNode.childNodes.count
    }
    
    func sceneGraph(childOfItem item: Any?, atIndex index: Int) -> Any {
        
        guard let sceneViewController = splitViewController?.sceneViewController, let meadow = sceneViewController.meadow else { return item! }
        
        if item == nil {
            
            return meadow.rootNode
        }
        if let item = item as? SceneGraphNode {
            
            if let child = item.sceneGraph(childAtIndex: index) {
                
                return child
            }
        }
        else if let item = item as? SCNNode {
            
            return item.childNodes[index]
        }
        
        return meadow.rootNode.childNodes[index]
    }
}

extension OrchardViewController: SceneGraphDelegate {
    
    func sceneGraph(outlineView: NSOutlineView, viewForItem item: Any, inColumn column: NSTableColumn?) -> NSView? {
        
        guard let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(SceneGraphCell.cellIdentifier), owner: self) as? SceneGraphCell else { return nil }
        
        guard let sceneViewController = splitViewController?.sceneViewController, let meadow = sceneViewController.meadow else { return view }
        
        if let item = item as? SCNNode, item == meadow.rootNode {
            
            view.textField?.stringValue = "Meadow"
            view.imageView?.image = NSImage(named: NSImage.Name("meadow_icon"))
        }
        if let item = item as? SceneGraphNode {
        
            view.textField?.stringValue = item.nodeName
            view.imageView?.image = NSImage(named: NSImage.Name("grid_icon"))
        }
        else if let _ = item as? CameraJib {
            
            view.textField?.stringValue = "Camera"
            view.imageView?.image = NSImage(named: NSImage.Name("grid_icon"))
        }
        
        return view
    }
}

extension OrchardViewController: GridDelegate {
    
    func didBecomeDirty(node: GridNode) {
        
        guard let sceneGraphViewController = splitViewController?.sceneGraphViewController else { return }
        
        sceneGraphViewController.outlineView.reloadData()
    }
}
