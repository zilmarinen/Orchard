//
//  FoliageUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

class FoliageUtilitiesViewController: NSViewController {

    @IBOutlet weak var chunkCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .foliage(let meadow):
            
            switch sender {
                
            case gridHiddenButton:
                
                meadow.scene.world.foliage.isHidden = sender.state == .off
                
            default: break
            }
            
            viewModel.state = .foliage(meadow: meadow)
            
        default: break
        }
    }
    
    var tabViewController: FoliageUtilitiesTabViewController?
    
    lazy var viewModel = {
        
        return FoliageUtilitiesViewModel(initialState: .empty(meadow: nil))
    }()
}

extension FoliageUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension FoliageUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .foliage(let meadow):
            
            chunkCount.integerValue = meadow.scene.world.foliage.totalChildren
            gridHiddenButton.state = (meadow.scene.world.foliage.isHidden ? .off : .on)
            
        default: break
        }
    }
}

extension FoliageUtilitiesViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? FoliageUtilitiesTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}

