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
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    
    @IBOutlet weak var buildButton: NSButton!
    @IBOutlet weak var terraformButton: NSButton!
    @IBOutlet weak var paintButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .inspecting(let grid):
            
            switch sender {
                
            case gridHiddenButton:
                
                grid.isHidden = sender.state == .off
                
            case buildButton:
                
                tabViewController?.viewModel.state = .build(grid)
                
            case terraformButton:
                
                tabViewController?.viewModel.state = .terraform(grid)
                
            case paintButton:
                
                tabViewController?.viewModel.state = .paint(grid)
                
            default: break
            }
            
            viewModel.state = .inspecting(grid)
            
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
            gridHiddenButton.state = (grid.isHidden ? .off : .on)
            
            guard let tabViewController = tabViewController else { break }
            
            switch tabViewController.viewModel.state {
                
            case .empty:
                
                tabViewController.viewModel.state = .build(grid)
                
            default: break
            }
            
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
