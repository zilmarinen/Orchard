//
//  PropUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

class PropUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var propCount: NSTextField!
    
    @IBOutlet weak var propsHiddenButton: NSButton!
    
    @IBOutlet weak var buildButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .area(let editor):
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                switch sender {
                    
                case propsHiddenButton:
                    
                    world.props.isHidden = sender.state == .off
                    
                case buildButton:
                    
                    tabViewController?.viewModel.state = .build(editor: editor)
                    
                default: break
                }
                
                viewModel.state = .area(editor: editor)
                
            default: break
            }
            
        default: break
        }
    }
    
    var tabViewController: PropUtilitiesTabViewController?

    lazy var viewModel = {
        
        return PropUtilitiesStateObserver(initialState: .empty(editor: nil))
    }()
}

extension PropUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension PropUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            guard let tabViewController = self.tabViewController else { return }
            
            switch to {
                
            case .empty(let editor):
                
                tabViewController.viewModel.state = .empty(editor: editor)
                
            case .area(let editor):
                
                switch editor.meadow.scene.model.state {
                    
                case .scene(let world):
                    
                    self.propCount.integerValue = world.areas.totalChildren
                    self.propsHiddenButton.state = (world.props.isHidden ? .off : .on)
                    
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

extension PropUtilitiesViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? PropUtilitiesTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}

