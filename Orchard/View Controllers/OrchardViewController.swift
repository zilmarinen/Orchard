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
    
    lazy var viewModel = {
        
        return OrchardViewModel(initialState: .editor(editor: (meadow: Meadow(observer: self), cursorModel: SceneView.CursorModel(), delegate: self)))
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
        
        viewModel.subscribe(stateDidChange)
    }
}

extension OrchardViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .editor(let editor):
            
            sceneGraphViewController?.delegate = self
            sceneGraphViewController?.viewModel.state = .sceneGraph(meadow: editor.meadow, child: editor.meadow)
            
            sceneViewController?.viewModel.state = .editor(editor: editor)
            
            sidebarViewController?.viewModel.state = .inspector(editor: editor, child: editor.meadow)
            
        case .loading(let editor, let intermediate):
            
            editor.meadow.load(intermediates: [intermediate])
            
            viewModel.state = .editor(editor: editor)
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
/*
extension OrchardViewController {
    
    enum KeyCodes: Int {
        
        case q = 12
        case w = 13
        case e = 14
        case a = 0
        case s = 1
        case d = 2
    }
    
    override func scrollWheel(with event: NSEvent) {
        
        switch viewModel.state {
            
        case .editor(let meadow):
            
            switch meadow.cameraJib.stateMachine.state {
                
            case .focus(let focus, let edge, let zoomLevel):
                
                let newZoomLevel = (zoomLevel + event.deltaY)
                
                meadow.cameraJib.stateMachine.state = .focus(focus, edge, newZoomLevel)
            }
            
        default: break
        }
    }
    
    override func keyUp(with event: NSEvent) {
        
        switch viewModel.state {
            
        case .editor(let meadow):
            
            guard let keyCode = KeyCodes(rawValue: Int(event.keyCode)) else { break }
            
            switch keyCode {
                
            case .q,
                 .e:
                
                switch meadow.cameraJib.stateMachine.state {
                    
                case .focus(let focus, let edge, let zoomLevel):
                    
                    let clockwise = (keyCode == .q)
                    
                    let nextEdge = GridEdge(rawValue: (clockwise ? (edge == .west ? GridEdge.north.rawValue : (edge.rawValue + 1)) : (edge == .north ? GridEdge.west.rawValue : (edge.rawValue - 1))))!
                    
                    meadow.cameraJib.stateMachine.state = .focus(focus, nextEdge, zoomLevel)
                }
                
            default: break
            }
            
        default: break
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        
        switch viewModel.state {
            
        case .editor(let meadow):
            
            guard let sceneView = sceneViewController?.sceneView else { break }
            
            let pointInView = sceneView.convert(event.locationInWindow, from: nil)
            
            let point = CGPoint(x: pointInView.x, y: pointInView.y)
            
            let hits = sceneView.hitTest(point, options: nil)
            
            let nodes = meadow.hitTest(hits: hits)
            
            if let node = nodes.first {
                
                sceneGraphViewController?.viewModel.state = .sceneGraph(meadow, node)
                
                sceneViewController?.viewModel.state = .inspecting(meadow, node)
                
                sidebarViewController?.viewModel.state = .inspecting(self, meadow, node)
            }
            
        default: break
        }
    }
}
*/
extension OrchardViewController: GridObserver {
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        switch viewModel.state {
            
        case .editor(let editor):
            
            guard let sceneGraphViewController = sceneGraphViewController, let sidebarViewController = sidebarViewController else { break }
            
            switch sceneGraphViewController.viewModel.state {
                
            case .sceneGraph(_, let item):
                
                sceneGraphViewController.viewModel.state = .sceneGraph(meadow: editor.meadow, child: item)
                
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
