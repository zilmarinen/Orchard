//
//  FootpathUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

class FootpathUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var chunkCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    
    @IBOutlet weak var buildButton: NSButton!
    @IBOutlet weak var paintButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .footpath(let editor):
            
            switch sender {
                
            case gridHiddenButton:
                
                editor.meadow.scene.world.footpaths.isHidden = sender.state == .off
                
            case buildButton:
                
                tabViewController?.viewModel.state = .build(editor: editor)
                
            case paintButton:
                
                tabViewController?.viewModel.state = .paint(editor: editor)
                
            default: break
            }
            
            viewModel.state = .footpath(editor: editor)
            
        default: break
        }
    }

    var tabViewController: FootpathUtilitiesTabViewController?
    
    lazy var viewModel = {
        
        return FootpathUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
}

extension FootpathUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension FootpathUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        guard let tabViewController = tabViewController else { return }
        
        switch to {
            
        case .footpath(let editor):
            
            chunkCount.integerValue = editor.meadow.scene.world.footpaths.totalChildren
            gridHiddenButton.state = (editor.meadow.scene.world.footpaths.isHidden ? .off : .on)
            
            switch tabViewController.viewModel.state {
                
            case .empty:
                
                tabViewController.viewModel.state = .build(editor: editor)
                
            default: break
            }
            
        default: break
        }
    }
}

extension FootpathUtilitiesViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? FootpathUtilitiesTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}

