//
//  SceneGraphViewController.swift
//  Orchard
//
//  Created by Zack Brown on 12/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

protocol SceneGraphDelegate {
 
    func sceneGraph(didSelectChild child: SceneGraphChild, atIndex index: Int)
}

class SceneGraphViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    var delegate: SceneGraphDelegate?
    
    lazy var viewModel = {
        
        return SceneGraphViewModel(initialState: .empty)
    }()
}

extension SceneGraphViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        outlineView.target = self
        outlineView.action = #selector(didSelectRow(sender:))
        
        outlineView.register(NSNib(nibNamed: NSNib.Name(SceneGraphCell.cellIdentifier), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(SceneGraphCell.cellIdentifier))
    
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension SceneGraphViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .sceneGraph(_, let child):
            
            DispatchQueue.main.async {
                
                self.outlineView.reloadData()
                
                if let child = child {
                    
                    let row = self.outlineView.row(forItem: child)
                    
                    let indexSet = IndexSet(integer: row)
                    
                    self.outlineView.selectRowIndexes(indexSet, byExtendingSelection: false)
                }
            }
            
        default: break
        }
    }
}

extension SceneGraphViewController {
    
    @objc func didSelectRow(sender: Any?) {
        
        guard let sender = sender as? NSOutlineView, let delegate = delegate else { return }
        
        let index = sender.selectedRow
        
        guard let child = sender.item(atRow: index) as? SceneGraphChild else { return }
        
        switch viewModel.state {
            
        case .sceneGraph(let scene, _):
            
            viewModel.state = .sceneGraph(scene: scene, child: child)
            
            delegate.sceneGraph(didSelectChild: child, atIndex: index)
            
        default: break
        }
    }
 
    func sceneGraph(numberOfChildrenOfItem item: Any?) -> Int {
        
        guard item != nil else { return 1 }
        
        if let item = item as? SceneGraphParent {
            
            return item.totalChildren
        }
        
        if let item = item as? SCNNode {
            
            return item.childNodes.count
        }
        
        return 0
    }
}

extension SceneGraphViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    
        return sceneGraph(numberOfChildrenOfItem: item)
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if let item = item as? SceneGraphParent, let child = item.child(at: index) {
            
            return child
        }
        
        if let item = item as? SCNNode {
            
            return item.childNodes[index]
        }
        
        switch viewModel.state {
            
        case .sceneGraph(let scene, _): return scene
            
        default: fatalError("Unable to find child of item \(String(describing: item))")
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        return sceneGraph(numberOfChildrenOfItem: item) != 0
    }
}

extension SceneGraphViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        guard let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(SceneGraphCell.cellIdentifier), owner: self) as? SceneGraphCell else { return nil }
        
        if let _ = item as? Scene {
            
            view.textField?.stringValue = "Meadow"
            view.imageView?.image = NSImage(named: NSImage.Name("meadow_icon"))
        }
        
        if let item = item as? SceneGraphChild {
            
            view.textField?.stringValue = item.name ?? ""
            view.imageView?.image = NSImage(named: NSImage.Name("grid_icon"))
        }
        
        return view
    }
}
