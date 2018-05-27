//
//  UtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import THRUtilities

class UtilitiesViewController: NSViewController {

    var tabViewController: UtilitiesTabViewController?
    
    @IBOutlet weak var areaButton: NSButton!
    @IBOutlet weak var foliageButton: NSButton!
    @IBOutlet weak var footpathButton: NSButton!
    @IBOutlet weak var terrainButton: NSButton!
    @IBOutlet weak var waterButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let tabViewController = tabViewController else { return }
        
        switch viewModel.state {
            
        case .inspecting(let meadow):
            
            switch sender {
                
            case areaButton:
                
                tabViewController.viewModel.state = .area(meadow.areas)
                
            case foliageButton:
                
                tabViewController.viewModel.state = .foliage(meadow.foliage)
                
            case footpathButton:
                
                tabViewController.viewModel.state = .footpath(meadow.footpaths)
                
            case terrainButton:
                
                tabViewController.viewModel.state = .terrain(meadow.terrain)
                
            case waterButton:
                
                tabViewController.viewModel.state = .water(meadow.water)
                
            default: break
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return UtilitiesViewModel(initialState: .empty)
    }()
}

extension UtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension UtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty:
            
            guard let tabViewController = tabViewController else { return }
            
            tabViewController.viewModel.state = .empty
            
        default: break
        }
    }
}

extension UtilitiesViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? UtilitiesTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}
