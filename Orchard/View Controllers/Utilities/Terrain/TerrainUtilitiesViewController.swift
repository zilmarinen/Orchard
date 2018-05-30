//
//  TerrainUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

class TerrainUtilitiesViewController: NSViewController {

    @IBOutlet weak var chunkCount: NSTextField!
    
    @IBOutlet weak var buildButton: NSButton!
    @IBOutlet weak var terraformButton: NSButton!
    @IBOutlet weak var paintButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let tabViewController = tabViewController else { return }
        
        switch viewModel.state {
            
        case .inspecting(let terrain):
            
            switch sender {
                
            case buildButton:
                
                tabViewController.viewModel.state = .build(terrain)
                
            case terraformButton:
                
                tabViewController.viewModel.state = .terraform(terrain)
                
            case paintButton:
                
                tabViewController.viewModel.state = .paint(terrain)
                
            default: break
            }
            
        default: break
        }
    }
    
    var tabViewController: TerrainUtilitiesTabViewController?
    
    lazy var viewModel = {
        
        return TerrainUtilitiesViewModel(initialState: .empty)
    }()
}

extension TerrainUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension TerrainUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
        
        case .inspecting(let grid):
            
            chunkCount.integerValue = grid.totalChildren
            
            guard let tabViewController = tabViewController else { break }
            
            tabViewController.viewModel.state = .build(grid)
            
        default: break
        }
    }
}

extension TerrainUtilitiesViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? TerrainUtilitiesTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}
