//
//  OrchardViewController.swift
//  Orchard
//
//  Created by Zack Brown on 12/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit
import THRUtilities

class OrchardViewController: NSViewController {
    
    lazy var viewModel: OrchardViewModel = {
        
        let input = Input(cursor: SceneView.Cursor(), graticule: SceneView.Graticule(), keyboard: SceneView.Keyboard())
        
        let meadow = Meadow(scene: Scene(observer: self), sceneView: self.sceneViewController!.sceneView, input: input)
        
        return OrchardViewModel(initialState: .editor(editor: (meadow: meadow, delegate: self)))
    }()
    
    var splitViewController: WindowSplitViewController?
    
    var sceneGraphViewController: SceneGraphViewController? {
        
        return splitViewController?.sceneGraphViewController
    }
    
    var sceneViewController: SceneViewController? {
        
        return splitViewController?.sceneViewController
    }
    
    var sidebarViewController: SidebarViewController? {
        
        return splitViewController?.sidebarViewController
    }
}

extension OrchardViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension OrchardViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .editor(let editor):
                
                self.sceneGraphViewController?.delegate = self
                self.sceneGraphViewController?.viewModel.state = .sceneGraph(scene: editor.meadow.scene, child: editor.meadow.scene)
                
                self.sceneViewController?.viewModel.state = .editor(editor: editor)
                
                self.sidebarViewController?.viewModel.state = .inspector(editor: editor, child: editor.meadow.scene)
                
            case .loading(let editor, let intermediate):
                
                editor.meadow.scene.load(intermediates: [intermediate])
                
                self.viewModel.state = .editor(editor: editor)
            }
        }
    }
}

extension OrchardViewController: SceneGraphDelegate {
    
    func sceneGraph(didSelectChild child: SceneGraphChild, atIndex index: Int) {
        
        switch viewModel.state {
            
        case .editor(let editor):
            
            sidebarViewController?.viewModel.state = .inspector(editor: editor, child: child)
        
        default: break
        }
    }
}

extension OrchardViewController: SceneGraphObserver {
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        switch viewModel.state {
            
        case .editor(let editor):
            
            guard let sceneGraphViewController = sceneGraphViewController, let sidebarViewController = sidebarViewController else { break }
            
            switch sceneGraphViewController.viewModel.state {
                
            case .sceneGraph(_, let child):
                
                sceneGraphViewController.viewModel.state = .sceneGraph(scene: editor.meadow.scene, child: child)
                
            default: break
            }
            
            switch sidebarViewController.viewModel.state {
                
            case .inspector(_, let child):
                
                sidebarViewController.viewModel.state = .inspector(editor: editor, child: child)
                
            default: break
            }
        
        default: break
        }
    }
}

extension OrchardViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedSplitView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedSplitView:
            
            guard let splitViewController = segue.destinationController as? WindowSplitViewController else { fatalError("Invalid segue destination") }
            
            self.splitViewController = splitViewController
        }
    }
}
