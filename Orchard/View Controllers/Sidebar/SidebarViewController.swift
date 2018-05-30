//
//  SidebarViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import THRUtilities

class SidebarViewController: NSViewController {

    var tabViewController: SidebarTabViewController?
    
    @IBOutlet weak var inspectorButton: NSButton!
    @IBOutlet weak var utilitiesButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let tabViewController = tabViewController else { return }
        
        switch viewModel.state {
            
        case .inspecting(let meadow):
        
            switch sender {
        
            case inspectorButton:
                
                tabViewController.viewModel.state = .inspector(meadow)
                
            case utilitiesButton:
                
                tabViewController.viewModel.state = .utilities(meadow)
            
            default: break
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return SidebarViewModel(initialState: .empty)
    }()
}

extension SidebarViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension SidebarViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let meadow):
            
            guard let tabViewController = tabViewController else { return }
            
            switch tabViewController.viewModel.state {
                
            case .empty:
                
                tabViewController.viewModel.state = .inspector(meadow)
                
            default: break
            }
            
        default: break
        }
    }
}

extension SidebarViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? SidebarTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}
