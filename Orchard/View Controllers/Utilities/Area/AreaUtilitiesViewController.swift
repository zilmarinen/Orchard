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
        
        switch viewModel.state {
            
        case .area(let editor):
            
            switch sender {
                
            case gridHiddenButton:
                
                editor.meadow.scene.world.areas.isHidden = sender.state == .off
                
            case buildButton:
                
                tabViewController?.viewModel.state = .build(editor: editor)
                
            case architectureButton:
                
                tabViewController?.viewModel.state = .architecture(editor: editor)
                
            case paintButton:
                
                tabViewController?.viewModel.state = .paint(editor: editor)
                
            case gridEdgeRenderStateButton:
                
                editor.meadow.scene.world.areas.renderState = (sender.state == .off ? .cutaway : .raised)
                
            default: break
            }
            
            viewModel.state = .area(editor: editor)
            
        default: break
        }
    }

    var tabViewController: AreaUtilitiesTabViewController?
    
    lazy var viewModel = {
        
        return AreaUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
}

extension AreaUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension AreaUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            guard let tabViewController = self.tabViewController else { return }
            
            switch to {
                
            case .empty(let editor):
                
                tabViewController.viewModel.state = .empty(editor: editor)
                
            case .area(let editor):
                
                self.chunkCount.integerValue = editor.meadow.scene.world.areas.totalChildren
                self.gridHiddenButton.state = (editor.meadow.scene.world.areas.isHidden ? .off : .on)
                
                self.gridEdgeRenderStateButton.state = (editor.meadow.scene.world.areas.renderState == .cutaway ? .off : .on)
                
                switch tabViewController.viewModel.state {
                    
                case .empty:
                    
                    tabViewController.viewModel.state = .build(editor: editor)
                    
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

