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
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .water(let meadow):
            
            switch sender {
                
            case gridHiddenButton:
                
                meadow.scene.world.water.isHidden = sender.state == .off
                
            default: break
            }
            
            viewModel.state = .water(meadow: meadow)
            
        default: break
        }
    }
    
    var tabViewController: WaterUtilitiesTabViewController?
    
    lazy var viewModel = {
        
        return WaterUtilitiesViewModel(initialState: .empty(meadow: nil))
    }()
}

extension WaterUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension WaterUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .water(let meadow):
            
            chunkCount.integerValue = meadow.scene.world.water.totalChildren
            gridHiddenButton.state = (meadow.scene.world.water.isHidden ? .off : .on)
            
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

