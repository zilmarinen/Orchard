//
//  WaterUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

class WaterUtilitiesViewController: NSViewController {

    @IBOutlet weak var chunkCount: NSTextField!
    
    var tabViewController: WaterUtilitiesTabViewController?
    
    lazy var viewModel = {
        
        return WaterUtilitiesViewModel(initialState: .empty)
    }()
}

extension WaterUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension WaterUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let grid):
            
            chunkCount.integerValue = grid.totalChildren
            
        default: break
        }
    }
}

extension WaterUtilitiesViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? WaterUtilitiesTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}

