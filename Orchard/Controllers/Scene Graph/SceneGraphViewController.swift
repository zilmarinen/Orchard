//
//  SceneGraphViewController.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow

class SceneGraphViewController: NSViewController {

    @IBOutlet weak var treeController: NSTreeController!
    @IBOutlet weak var outlineView: NSOutlineView!
    
    weak var coordinator: SceneGraphCoordinator?
}

extension SceneGraphViewController {

    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        outlineView.target = self
        outlineView.action = #selector(didSelectRow(sender:))
        outlineView.rowHeight = 18
    }
}

extension SceneGraphViewController {

    @objc func didSelectRow(sender: NSOutlineView) {
        
        guard let node = treeController.selectedObjects.first as? SceneGraphNode else { return }
    
        coordinator?.didSelect(node: node)
    }
}
