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
        
        return OrchardViewModel(initialState: .empty)
    }()
    
    lazy var meadow = {
        
       return Meadow(observer: self)
        
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
            
        case .editor(let meadow):
            
            sceneGraphViewController?.delegate = self
            sceneGraphViewController?.viewModel.state = .editor(meadow)
            
            sceneViewController?.viewModel.state = .editor(meadow)
            
            sidebarViewController?.viewModel.state = .empty
            
        default: break
        }
    }
}

extension OrchardViewController: SceneGraphDelegate {
    
    func sceneGraph(didSelectChild child: SceneGraphChild, atIndex index: Int) {
        
        switch viewModel.state {
            
        case .editor(let meadow):
            
            sceneGraphViewController?.viewModel.state = .inspecting(meadow, child)
            
            sceneViewController?.viewModel.state = .inspecting(meadow, child)
            
            sidebarViewController?.viewModel.state = .inspecting(self, meadow, child)
            
        default: break
        }
    }
}

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
                
                sceneGraphViewController?.viewModel.state = .inspecting(meadow, node)
                
                sceneViewController?.viewModel.state = .inspecting(meadow, node)
                
                sidebarViewController?.viewModel.state = .inspecting(self, meadow, node)
            }
            
        default: break
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        
    }
}

extension OrchardViewController: GridObserver {
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        switch viewModel.state {
            
        case .editor(let meadow):
            
            guard let sceneGraphViewController = sceneGraphViewController, let sidebarViewController = sidebarViewController else { break }
            
            switch sceneGraphViewController.viewModel.state {
                
            case .inspecting(_, let item):
                
                sceneGraphViewController.viewModel.state = .inspecting(meadow, item)
                
            default: break
            }
            
            switch sidebarViewController.viewModel.state {
                
            case .inspecting(let delegate, _, let item):
                
                sidebarViewController.viewModel.state = .inspecting(delegate, meadow, item)
                
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
