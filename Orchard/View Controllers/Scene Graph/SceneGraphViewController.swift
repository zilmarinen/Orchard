//
//  SceneGraphViewController.swift
//  Orchard
//
//  Created by Zack Brown on 12/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class SceneGraphViewController: NSViewController {

    @IBOutlet var treeController: NSTreeController!
    
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
