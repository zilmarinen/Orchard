//
//  FootpathBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class FootpathBuildUtilitiesViewController: NSViewController {

    lazy var viewModel = {
        
        return FootpathBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
}
