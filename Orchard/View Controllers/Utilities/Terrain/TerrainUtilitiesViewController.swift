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
            
        case .terrain(let editor):
            
            switch sender {
                
            case gridHiddenButton:
                
                editor.meadow.scene.world.terrain.isHidden = sender.state == .off
                
            case buildButton:
                
                tabViewController?.viewModel.state = .build(editor: editor)
                
            case terraformButton:
                
                tabViewController?.viewModel.state = .terraform(editor: editor)
                
            case paintButton:
                
                tabViewController?.viewModel.state = .paint(editor: editor)
                
            default: break
            }
            
            viewModel.state = .terrain(editor: editor)
            
        default: break
        }
    }
    
    var tabViewController: TerrainUtilitiesTabViewController?
    
    lazy var viewModel = {
        
        return TerrainUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
}

extension TerrainUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        guard let tabViewController = tabViewController else { return }
        
        switch to {
            
        case .empty(let editor):
            
            tabViewController.viewModel.state = .empty(editor: editor)
        
        case .terrain(let editor):
            
            chunkCount.integerValue = editor.meadow.scene.world.terrain.totalChildren
            gridHiddenButton.state = (editor.meadow.scene.world.terrain.isHidden ? .off : .on)
            
            switch tabViewController.viewModel.state {
                
            case .empty:
                
                tabViewController.viewModel.state = .build(editor: editor)
                
            default: break
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
