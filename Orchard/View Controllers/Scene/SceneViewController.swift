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
        
        viewModel.subscribe(stateDidChange)
    }
}

extension SceneViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .editor(let meadow, let cursorModel):
            
            sceneView.viewModel.state = .scene(meadow, cursorModel)
            
            sceneView.showsStatistics = true
            sceneView.isPlaying = true
            
        default: break
        }
    }
}
