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
    
    @IBOutlet weak var buildButton: NSButton!
    @IBOutlet weak var paintButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch stateObserver.state {
            
        case .foliage(let editor):
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                switch sender {
                    
                case gridHiddenButton:
                    
                    world.foliage.isHidden = sender.state == .off
                    
                case buildButton:
                    
                    tabViewController?.stateObserver.state = .build(editor: editor)
                    
                case paintButton:
                    
                    tabViewController?.stateObserver.state = .paint(editor: editor)
                    
                default: break
                }
                
                stateObserver.state = .foliage(editor: editor)
                
            default: break
            }
            
        default: break
        }
    }
    
    var tabViewController: FoliageUtilitiesTabViewController?
    
    lazy var stateObserver = {
        
        return FoliageUtilitiesStateObserver(initialState: .empty(editor: nil))
    }()
}

extension FoliageUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension FoliageUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            guard let tabViewController = self.tabViewController else { return }
            
            switch to {
                
            case .foliage(let editor):
                
                switch editor.meadow.scene.model.state {
                    
                case .scene(let world):
                    
                    self.chunkCount.integerValue = world.foliage.totalChildren
                    self.gridHiddenButton.state = (world.foliage.isHidden ? .off : .on)
                    
                    switch tabViewController.stateObserver.state {
                        
                    case .empty:
                        
                        tabViewController.stateObserver.state = .build(editor: editor)
                        
                    default: break
                    }
                    
                default: break
                }
                
            default: break
            }
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

