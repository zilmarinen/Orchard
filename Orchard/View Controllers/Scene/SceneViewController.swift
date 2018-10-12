//
//  SceneViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class SceneViewController: NSViewController {

    @IBOutlet weak var sceneView: SceneView!
    
    lazy var viewModel = {
        
        return SceneViewModel(initialState: .empty)
    }()
}

extension SceneViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension SceneViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .editor(let editor):
            
            editor.meadow.sceneView.viewModel.state = .scene(scene: editor.meadow.scene, input: editor.meadow.input)
            
            editor.meadow.sceneView.showsStatistics = true
            editor.meadow.sceneView.isPlaying = true
            
        default: break
        }
    }
}
