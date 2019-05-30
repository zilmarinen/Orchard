//
//  SceneGraphViewController.swift
//  Orchard
//
//  Created by Zack Brown on 12/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

protocol SceneGraphDelegate {
 
    func sceneGraph(didSelectChild child: SceneGraphChild, atIndex index: Int)
}

class SceneGraphViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    var delegate: SceneGraphDelegate?
    
    lazy var viewModel = {
        
        return SceneGraphViewModel(initialState: .empty)
    }()
}

extension SceneGraphViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        outlineView.target = self
        outlineView.action = #selector(didSelectRow(sender:))
        
        outlineView.register(NSNib(nibNamed: NSNib.Name(SceneGraphCell.cellIdentifier), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(SceneGraphCell.cellIdentifier))
    
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension SceneGraphViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .sceneGraph(_, let child):
                
                self.outlineView.reloadData()
                
                if let child = child {
                    
                    let row = self.outlineView.row(forItem: child)
                    
                    let indexSet = IndexSet(integer: row)
                    
                    self.outlineView.selectRowIndexes(indexSet, byExtendingSelection: false)
                }
                
            default: break
            }
        }
    }
}

extension SceneGraphViewController {
    
    @objc func didSelectRow(sender: Any?) {
        
        guard let sender = sender as? NSOutlineView, let delegate = delegate else { return }
        
        let index = sender.selectedRow
        
        guard let child = sender.item(atRow: index) as? SceneGraphChild else { return }
        
        switch viewModel.state {
            
        case .sceneGraph(let scene, _):
            
            viewModel.state = .sceneGraph(scene: scene, child: child)
            
            delegate.sceneGraph(didSelectChild: child, atIndex: index)
            
        default: break
        }
    }
 
    func sceneGraph(numberOfChildrenOfItem item: Any?) -> Int {
        
        switch viewModel.state {
            
        case .sceneGraph:
            
            guard item != nil else { return 1 }
            
            if let item = item as? SceneGraphParent {
                
                return item.totalChildren
            }
            
            return 0
            
        default: return 0
        }
    }
}

extension SceneGraphViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    
        return sceneGraph(numberOfChildrenOfItem: item)
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if let item = item as? SceneGraphParent {
         
            return item.child(at: index)!
        }
        
        switch viewModel.state {
            
        case .sceneGraph(let scene, _): return scene
            
        default: fatalError("Unable to find child of item \(String(describing: item))")
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        return sceneGraph(numberOfChildrenOfItem: item) != 0
    }
}

extension SceneGraphViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        guard let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(SceneGraphCell.cellIdentifier), owner: self) as? SceneGraphCell else { return nil }
        
        if let child = item as? SceneGraphChild {
            
            view.textField?.stringValue = child.name ?? ""
            
            if #available(OSX 10.14, *) {
                view.imageView?.contentTintColor = NSColor.white
            }
        }
        
        switch type(of: item) {
        
        case is Actors.Type: view.imageView?.image = NSImage(named: NSImage.Name("actors_icon"))
        case is Area.Type: view.imageView?.image = NSImage(named: NSImage.Name("area_icon"))
        case is Foliage.Type: view.imageView?.image = NSImage(named: NSImage.Name("foliage_icon"))
        case is Footpath.Type: view.imageView?.image = NSImage(named: NSImage.Name("footpath_icon"))
        case is Props.Type: view.imageView?.image = NSImage(named: NSImage.Name("props_icon"))
        case is Scaffold.Type: view.imageView?.image = NSImage(named: NSImage.Name("scaffold_icon"))
        case is Terrain.Type: view.imageView?.image = NSImage(named: NSImage.Name("terrain_icon"))
        case is Tunnel.Type: view.imageView?.image = NSImage(named: NSImage.Name("tunnel_icon"))
        case is Water.Type: view.imageView?.image = NSImage(named: NSImage.Name("water_icon"))
            
        case is AreaChunk.Type,
             is FoliageChunk.Type,
             is FootpathChunk.Type,
             is TerrainChunk.Type,
             is WaterChunk.Type:
            
        view.imageView?.image = NSImage(named: NSImage.Name("chunk_icon"))
            
        case is AreaTile.Type,
             is FoliageTile.Type,
             is FootpathTile.Type,
             is TerrainTile.Type,
             is WaterTile.Type:
            
        view.imageView?.image = NSImage(named: NSImage.Name("tile_icon"))
            
        case is AreaNode<AreaNodeEdge>.Type,
             is FoliageNode.Type,
             is FootpathNode.Type,
             is TerrainNode<TerrainNodeEdge<TerrainNodeEdgeLayer>>.Type,
             is WaterNode<WaterNodeEdge>.Type:
            
        view.imageView?.image = NSImage(named: NSImage.Name("node_icon"))
            
        case is AreaNodeEdge.Type,
             is WaterNodeEdge.Type,
             is TerrainNodeEdge<TerrainNodeEdgeLayer>.Type:
            
            view.imageView?.image = NSImage(named: NSImage.Name("edge_icon"))
            
        case is TerrainNodeEdgeLayer.Type:
            
            view.imageView?.image = NSImage(named: NSImage.Name("layer_icon"))
            
        default: break
        }
        
        return view
    }
}
