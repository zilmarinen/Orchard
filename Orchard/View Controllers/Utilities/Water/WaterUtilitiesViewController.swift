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
    
    @IBOutlet weak var buildButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .water(let editor):
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                switch sender {
                    
                case gridHiddenButton:
                    
                    world.water.isHidden = sender.state == .off
                    
                case buildButton:
                    
                    tabViewController?.viewModel.state = .build(editor: editor)
                    
                default: break
                }
                
                viewModel.state = .water(editor: editor)
                
            default: break
            }
            
        default: break
        }
    }
    
    var tabViewController: WaterUtilitiesTabViewController?
    
    lazy var viewModel = {
        
        return WaterUtilitiesViewModel(initialState: .empty(editor: nil))
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
        
        DispatchQueue.main.async {
            
            guard let tabViewController = self.tabViewController else { return }
            
            switch to {
                
            case .empty(let editor):
                
                tabViewController.viewModel.state = .empty(editor: editor)
                
            case .water(let editor):
                
                switch editor.meadow.scene.model.state {
                    
                case .scene(let world):
                    
                    self.chunkCount.integerValue = world.water.totalChildren
                    self.gridHiddenButton.state = (world.water.isHidden ? .off : .on)
                    
                    switch tabViewController.viewModel.state {
                        
                    case .empty:
                        
                        tabViewController.viewModel.state = .build(editor: editor)
                        
                    default: break
                    }
                    
                default: break
                }
            }
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

