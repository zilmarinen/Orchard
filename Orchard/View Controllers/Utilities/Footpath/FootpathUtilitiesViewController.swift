//
//  FootpathUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

class FootpathUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var chunkCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .footpath(let meadow):
            
            switch sender {
                
            case gridHiddenButton:
                
                meadow.scene.world.footpaths.isHidden = sender.state == .off
                
            default: break
            }
            
            viewModel.state = .footpath(meadow: meadow)
            
        default: break
        }
    }

    var tabViewController: FootpathUtilitiesTabViewController?
    
    lazy var viewModel = {
        
        return FootpathUtilitiesViewModel(initialState: .empty(meadow: nil))
    }()
}

extension FootpathUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension FootpathUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .footpath(let meadow):
            
            chunkCount.integerValue = meadow.scene.world.footpaths.totalChildren
            gridHiddenButton.state = (meadow.scene.world.footpaths.isHidden ? .off : .on)
            
        default: break
        }
    }
}

extension FootpathUtilitiesViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? FootpathUtilitiesTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}

