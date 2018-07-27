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
    
    var sidebarTabViewController: SidebarTabViewController? {
        
        return splitViewController?.sidebarViewController?.tabViewController
    }
    
    var inspectorTabViewController: InspectorTabViewController? {
        
        return splitViewController?.sidebarViewController?.tabViewController?.inspectorTabViewController
    }
    
    var utilitiesTabViewController: UtilitiesTabViewController? {
        
        return splitViewController?.sidebarViewController?.tabViewController?.utilitiesTabViewController
    }
}

extension OrchardViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let meadow = sceneViewController?.meadow else { return }
        
        sidebarViewController?.viewModel.state = .inspecting(meadow)
    }
}

extension OrchardViewController: SceneGraphDataSource {
    
    func sceneGraph(numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil {
            
            return 1
        }
        if let item = item as? SceneGraphNode {
            
            return item.totalChildren
        }
        else if let _ = item as? CameraJib {
            
            return 0
        }
        
        guard let meadow = sceneViewController?.meadow else { return 0 }
        
        return meadow.rootNode.childNodes.count
    }
    
    func sceneGraph(childOfItem item: Any?, atIndex index: Int) -> Any {
        
        guard let meadow = sceneViewController?.meadow else { return item! }
        
        if item == nil {
            
            return meadow.rootNode
        }
        if let item = item as? SceneGraphNode {
            
            if let child = item.sceneGraph(childAtIndex: index) {
                
                return child
            }
        }
        else if let item = item as? SCNNode {
            
            return item.childNodes[index]
        }
        
        return meadow.rootNode.childNodes[index]
    }
}

extension OrchardViewController: SceneGraphDelegate {
    
    func sceneGraph(outlineView: NSOutlineView, viewForItem item: Any, inColumn column: NSTableColumn?) -> NSView? {
        
        guard let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(SceneGraphCell.cellIdentifier), owner: self) as? SceneGraphCell else { return nil }
        
        guard let sceneViewController = sceneViewController, let meadow = sceneViewController.meadow else { return view }
        
        if let item = item as? SCNNode, item == meadow.rootNode {
            
            view.textField?.stringValue = "Meadow"
            view.imageView?.image = NSImage(named: NSImage.Name("meadow_icon"))
        }
        else if let _ = item as? CameraJib {
            
            view.textField?.stringValue = "Camera"
            view.imageView?.image = NSImage(named: NSImage.Name("grid_icon"))
        }
        else if let item = item as? SceneGraphNode {
            
            view.textField?.stringValue = item.nodeName
            view.imageView?.image = NSImage(named: NSImage.Name("grid_icon"))
        }
        
        return view
    }
    
    func sceneGraph(outlineView: NSOutlineView, didSelectItem item: Any, atIndex index: Int) {
    
        guard let meadow = sceneViewController?.meadow else { return }
        
        if let item = item as? SceneGraphNode {
            
            let vector = SCNVector3(x: MDWFloat(item.volume.coordinate.x), y: World.Y(y: item.volume.coordinate.y), z: MDWFloat(item.volume.coordinate.z))
            
            switch meadow.cameraJib.stateMachine.state {
                
            case .focus(_, let edge, let zoomLevel):
                
                meadow.cameraJib.stateMachine.state = .focus(vector, edge, zoomLevel)
            }
        }
        
        switch type(of: item) {
            
        case is CameraJib.Type:
            
            sidebarTabViewController?.viewModel.state = .inspector(meadow)
            inspectorTabViewController?.viewModel.state = .camera(item as! CameraJib)
            utilitiesTabViewController?.viewModel.state = .empty
            
        case is Area.Type,
             is AreaChunk.Type,
             is AreaTile.Type,
             is AreaNode.Type:
            
            inspectorTabViewController?.viewModel.state = .area(meadow.areas, item as? AreaChunk, item as? AreaTile, item as? AreaNode)
            utilitiesTabViewController?.viewModel.state = .area(meadow.areas)
            
        case is Foliage.Type,
             is FoliageChunk.Type,
             is FoliageTile.Type,
             is FoliageNode.Type:
            
            inspectorTabViewController?.viewModel.state = .foliage(meadow.foliage, item as? FoliageChunk, item as? FoliageTile, item as? FoliageNode)
            utilitiesTabViewController?.viewModel.state = .foliage(meadow.foliage)
            
        case is Footpath.Type,
             is FootpathChunk.Type,
             is FootpathTile.Type,
             is FootpathNode.Type:
            
            inspectorTabViewController?.viewModel.state = .footpath(meadow.footpaths, item as? FootpathChunk, item as? FootpathTile, item as? FootpathNode)
            utilitiesTabViewController?.viewModel.state = .footpath(meadow.footpaths)
            
        case is Terrain.Type,
             is TerrainChunk.Type,
             is TerrainTile.Type,
             is TerrainNode.Type,
             is TerrainLayer.Type:
            
            inspectorTabViewController?.viewModel.state = .terrain(meadow.terrain, item as? TerrainChunk, item as? TerrainTile, item as? TerrainNode, item as? TerrainLayer)
            utilitiesTabViewController?.viewModel.state = .terrain(meadow.terrain)
            
        case is Water.Type,
             is WaterChunk.Type,
             is WaterTile.Type,
             is WaterNode.Type:
            
            inspectorTabViewController?.viewModel.state = .water(meadow.water, item as? WaterChunk, item as? WaterTile, item as? WaterNode)
            utilitiesTabViewController?.viewModel.state = .water(meadow.water)
            
        default:
            
            inspectorTabViewController?.viewModel.state = .empty
            utilitiesTabViewController?.viewModel.state = .empty
            
            if let item = item as? SCNNode, item == meadow.rootNode {
                
                sidebarTabViewController?.viewModel.state = .inspector(meadow)
                inspectorTabViewController?.viewModel.state = .scene(meadow)
            }
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
        
        guard let meadow = sceneViewController?.meadow else { return }
        
        switch meadow.cameraJib.stateMachine.state {
            
        case .focus(let focus, let edge, let zoomLevel):
            
            let newZoomLevel = (zoomLevel + event.deltaY)
            
            meadow.cameraJib.stateMachine.state = .focus(focus, edge, newZoomLevel)
        }
    }
    
    override func keyUp(with event: NSEvent) {
        
        guard let meadow = sceneViewController?.meadow, let keyCode = KeyCodes(rawValue: Int(event.keyCode)) else { return }
        
        switch keyCode {
            
        case .q,
             .e:
            
            switch meadow.cameraJib.stateMachine.state {
                
            case .focus(let focus, let edge, let zoomLevel):
                
                let clockwise = (keyCode == .q)
                
                let nextEdge = GridEdge(rawValue: (clockwise ? (edge == .west ? GridEdge.north.rawValue : (edge.rawValue + 1)) : (edge == .north ? GridEdge.west.rawValue : (edge.rawValue - 1))))!
                
                meadow.cameraJib.stateMachine.state = .focus(focus, nextEdge, zoomLevel)
            }
        case .a:
            
            print("a")
            
        default: break
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        
        
    }
    
    override func rightMouseDown(with event: NSEvent) {
        
    }
}

extension OrchardViewController: SoilableDelegate {
    
    func didBecomeDirty(soilable: Soilable) {
        
        DispatchQueue.main.async {
            
            self.sceneGraphViewController?.outlineView.reloadData()
            
            self.sceneViewController?.sceneView.isPlaying = true
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
            
            if let sceneGraphViewController = sceneGraphViewController {
                
                sceneGraphViewController.dataSource = self
                sceneGraphViewController.delegate = self
            }
            
            if let sceneViewController = sceneViewController {
                
                sceneViewController.delegate = self
            }
        }
    }
}
