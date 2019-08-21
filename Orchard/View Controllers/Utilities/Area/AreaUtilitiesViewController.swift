//
//  AreaUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

class AreaUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var chunkCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    
    @IBOutlet weak var gridEdgeRenderStateButton: NSButton!
    
    @IBOutlet weak var buildButton: NSButton!
    @IBOutlet weak var architectureButton: NSButton!
    @IBOutlet weak var paintButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch stateObserver.state {
            
        case .area(let editor):
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                switch sender {
                    
                case gridHiddenButton:
                    
                    world.areas.isHidden = sender.state == .off
                    
                case buildButton:
                    
                    tabViewController?.stateObserver.state = .build(editor: editor)
                    
                case architectureButton:
                    
                    tabViewController?.stateObserver.state = .architecture(editor: editor)
                    
                case paintButton:
                    
                    tabViewController?.stateObserver.state = .paint(editor: editor)
                    
                case gridEdgeRenderStateButton:
                    
                    world.areas.renderState = (sender.state == .off ? .cutaway : .raised)
                    
                default: break
                }
                
                stateObserver.state = .area(editor: editor)
                
            default: break
            }
            
        default: break
        }
    }

    var tabViewController: AreaUtilitiesTabViewController?
    
    lazy var stateObserver = {
        
        return AreaUtilitiesStateObserver(initialState: .empty(editor: nil))
    }()
}

extension AreaUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension AreaUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            guard let tabViewController = self.tabViewController else { return }
            
            switch to {
                
            case .empty(let editor):
                
                tabViewController.stateObserver.state = .empty(editor: editor)
                
            case .area(let editor):
                
                switch editor.meadow.scene.model.state {
                    
                case .scene(let world):
                    
                    self.chunkCount.integerValue = world.areas.totalChildren
                    self.gridHiddenButton.state = (world.areas.isHidden ? .off : .on)
                    
                    self.gridEdgeRenderStateButton.state = (world.areas.renderState == .cutaway ? .off : .on)
                    
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

extension AreaUtilitiesViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? AreaUtilitiesTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}

