//
//  SidebarViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import THRUtilities

class SidebarViewController: NSViewController {

    var tabViewController: SidebarTabViewController?
    
    @IBOutlet weak var inspectorButton: NSButton!
    @IBOutlet weak var utilitiesButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .inspector(let editor, let child):
            
            switch sender {
                
            case utilitiesButton:
                
                viewModel.state = .utility(editor: editor, child: child)
                
            default: break
            }
            
        case .utility(let editor, let child):
            
            switch sender {
                
            case inspectorButton:
                
                viewModel.state = .inspector(editor: editor, child: child)
                
            default: break
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return SidebarViewModel(initialState: .empty(editor: nil))
    }()
}

extension SidebarViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension SidebarViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            guard let tabViewController = self.tabViewController else { return }
            
            switch to {
                
            case .empty(let editor):
                
                tabViewController.viewModel.state = .empty(editor: editor)
                
            case .inspector(let editor, let child):
                
                tabViewController.viewModel.state = .inspector(editor: editor, child: child)
                
            case .utility(let editor, _):
                
                tabViewController.viewModel.state = .utility(editor: editor)
            }
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
