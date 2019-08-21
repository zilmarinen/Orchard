//
//  SidebarTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class SidebarTabViewController: NSTabViewController {
    
    var inspectorTabViewController: InspectorTabViewController? {
        
        return children.first { return type(of: $0) == InspectorTabViewController.self } as? InspectorTabViewController
    }
    
    var utilitiesTabViewController: UtilitiesTabViewController? {
        
        return children.first { return type(of: $0) == UtilitiesTabViewController.self } as? UtilitiesTabViewController
    }

    lazy var stateObserver = {
        
        return SidebarTabStateObserver(initialState: .empty(editor: nil))
    }()
}

extension SidebarTabViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension SidebarTabViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            guard let inspectorTabViewController = self.inspectorTabViewController, let utilitiesTabViewController = self.utilitiesTabViewController else { return }
            
            if let from = from {
                
                switch from {
                    
                case .utility(let editor):
                    
                    utilitiesTabViewController.stateObserver.state = .empty(editor: editor)
                    
                default: break
                }
            }
            
            self.selectedTabViewItemIndex = to.tab.rawValue
            
            switch to {
                
            case .empty(let editor):
                
                inspectorTabViewController.stateObserver.state = .empty
                utilitiesTabViewController.stateObserver.state = .empty(editor: editor)
                
            case .inspector(let editor, let child):
                
                switch editor.meadow.scene.model.state {
                    
                case .scene(let world):
                    
                    switch type(of: child) {
                        
                    case is Area.Type,
                         is AreaChunk.Type,
                         is AreaTile.Type,
                         is AreaNode<AreaNodeEdge>.Type,
                         is AreaNodeEdge.Type:
                        
                        inspectorTabViewController.stateObserver.state = .area(editor: editor, inspectable: (world.areas, child as? AreaChunk, child as? AreaTile, child as? AreaNode, child as? AreaNodeEdge))
                        
                    case is Foliage.Type,
                         is FoliageChunk.Type,
                         is FoliageTile.Type,
                         is FoliageNode.Type:
                        
                        inspectorTabViewController.stateObserver.state = .foliage(editor: editor, inspectable: (world.foliage, child as? FoliageChunk, child as? FoliageTile, child as? FoliageNode))
                        
                    case is Footpath.Type,
                         is FootpathChunk.Type,
                         is FootpathTile.Type,
                         is FootpathNode.Type:
                        
                        inspectorTabViewController.stateObserver.state = .footpath(editor: editor, inspectable: (world.footpaths, child as? FootpathChunk, child as? FootpathTile, child as? FootpathNode))
                        
                    case is Props.Type,
                         is Prop.Type:
                        
                        inspectorTabViewController.stateObserver.state = .prop(editor: editor, inspectable: (props: world.props, child as? Prop))
                        
                    case is Terrain.Type,
                         is TerrainChunk.Type,
                         is TerrainTile.Type,
                         is TerrainNode<TerrainNodeEdge<TerrainNodeEdgeLayer>>.Type,
                         is TerrainNodeEdge<TerrainNodeEdgeLayer>.Type,
                         is TerrainNodeEdgeLayer.Type:
                        
                        inspectorTabViewController.stateObserver.state = .terrain(editor: editor, inspectable: (world.terrain, child as? TerrainChunk, child as? TerrainTile, child as? TerrainNode, child as? TerrainNodeEdge, child as? TerrainNodeEdgeLayer))
                        
                    case is Water.Type,
                         is WaterChunk.Type,
                         is WaterTile.Type,
                         is WaterNode<WaterNodeEdge>.Type,
                         is WaterNodeEdge.Type:
                        
                        inspectorTabViewController.stateObserver.state = .water(editor: editor, inspectable: (world.water, child as? WaterChunk, child as? WaterTile, child as? WaterNode, child as? WaterNodeEdge))
                        
                    case is SceneKitScene.Type:
                        
                        inspectorTabViewController.stateObserver.state = .scene(editor: editor)
                        
                    default:
                        
                        inspectorTabViewController.stateObserver.state = .empty
                    }
                    
                default: break
                }
                
            case .utility(let editor):
                
                switch inspectorTabViewController.stateObserver.state {
                
                case .area:
                    
                    utilitiesTabViewController.stateObserver.state = .area(editor: editor)
                    
                case .foliage:
                    
                    utilitiesTabViewController.stateObserver.state = .foliage(editor: editor)
                    
                case .footpath:
                    
                    utilitiesTabViewController.stateObserver.state = .footpath(editor: editor)
                    
                case .prop:
                    
                    utilitiesTabViewController.stateObserver.state = .prop(editor: editor)
                    
                case .terrain:
                    
                    utilitiesTabViewController.stateObserver.state = .terrain(editor: editor)
                    
                case .water:
                    
                    utilitiesTabViewController.stateObserver.state = .water(editor: editor)
                    
                default:
                    
                    utilitiesTabViewController.stateObserver.state = .empty(editor: editor)
                }
            }
        }
    }
}
