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
    
    lazy var stateObserver: OrchardStateObserver = {
        
        let input = Input(cursor: SceneKitView.Cursor(), graticule: SceneKitView.Graticule(), keyboard: SceneKitView.Keyboard())
        
        let meadow = Meadow(input: input, view: self.sceneViewController!.sceneView, observer: self, delegate: self)
        
        return OrchardStateObserver(initialState: .editor(editor: (meadow: meadow, delegate: self)))
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
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension OrchardViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .editor(let editor):
                
                self.sceneGraphViewController?.delegate = self
                self.sceneGraphViewController?.stateObserver.state = .sceneGraph(scene: editor.meadow.scene, child: editor.meadow.scene)
                
                self.sceneViewController?.stateObserver.state = .editor(editor: editor)
                
                self.sidebarViewController?.stateObserver.state = .inspector(editor: editor, child: editor.meadow.scene)
                
                switch editor.meadow.scene.model.state {
                    
                case .empty:
                    
                    let world = World()
                    
                    editor.meadow.scene.model.show(world: world)
                    
                    editor.meadow.scene.cameraJib.model.state = .orbit(vector: world.position, edge: .north, zoom: SceneKitCamera.maximumZoomLevel)
                    
                default: break
                }
                
            case .loading(let editor, let map):
                
                editor.meadow.scene.model.load(map: map)
                
                self.stateObserver.state = .editor(editor: editor)
            }
        }
    }
}

extension OrchardViewController: SceneGraphDelegate {
    
    func sceneGraph(didSelectChild child: SceneGraphChild, atIndex index: Int) {
        
        switch stateObserver.state {
            
        case .editor(let editor):
            
            sidebarViewController?.stateObserver.state = .inspector(editor: editor, child: child)
        
        default: break
        }
    }
}

extension OrchardViewController: SceneGraphObserver {
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        switch stateObserver.state {
            
        case .editor(let editor):
            
            guard let sceneGraphViewController = sceneGraphViewController, let sidebarViewController = sidebarViewController else { break }
            
            switch sceneGraphViewController.stateObserver.state {
                
            case .sceneGraph(_, let child):
                
                sceneGraphViewController.stateObserver.state = .sceneGraph(scene: editor.meadow.scene, child: child)
                
            default: break
            }
            
            switch sidebarViewController.stateObserver.state {
                
            case .inspector(_, let child):
                
                sidebarViewController.stateObserver.state = .inspector(editor: editor, child: child)
                
            default: break
            }
        
        default: break
        }
    }
}

extension OrchardViewController: SceneRendererDelegate {
    
    func update(deltaTime: TimeInterval, frameTime: TimeInterval) {
        
        switch stateObserver.state {
            
        case .editor:
            
            sceneViewController?.update(deltaTime: deltaTime, frameTime: frameTime)
            
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
