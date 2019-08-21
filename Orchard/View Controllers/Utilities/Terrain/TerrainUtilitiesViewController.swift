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
        
        switch stateObserver.state {
            
        case .terrain(let editor):
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                switch sender {
                    
                case gridHiddenButton:
                    
                    world.terrain.isHidden = sender.state == .off
                    
                case buildButton:
                    
                    tabViewController?.stateObserver.state = .build(editor: editor)
                    
                case terraformButton:
                    
                    tabViewController?.stateObserver.state = .terraform(editor: editor)
                    
                case paintButton:
                    
                    tabViewController?.stateObserver.state = .paint(editor: editor)
                    
                default: break
                }
                
                stateObserver.state = .terrain(editor: editor)
                
            default: break
            }
            
        default: break
        }
    }
    
    var tabViewController: TerrainUtilitiesTabViewController?
    
    lazy var stateObserver = {
        
        return TerrainUtilitiesStateObserver(initialState: .empty(editor: nil))
    }()
}

extension TerrainUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            guard let tabViewController = self.tabViewController else { return }
            
            switch to {
                
            case .empty(let editor):
                
                tabViewController.stateObserver.state = .empty(editor: editor)
            
            case .terrain(let editor):
                
                switch editor.meadow.scene.model.state {
                    
                case .scene(let world):
                    
                    self.chunkCount.integerValue = world.terrain.totalChildren
                    self.gridHiddenButton.state = (world.terrain.isHidden ? .off : .on)
                    
                    switch tabViewController.stateObserver.state {
                        
                    case .empty:
                        
                        tabViewController.stateObserver.state = .build(editor: editor)
                        
                    default: break
                    }
                    
                default: break
                }
            }
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
