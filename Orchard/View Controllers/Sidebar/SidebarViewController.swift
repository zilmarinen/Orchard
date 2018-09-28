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
        
        guard let tabViewController = tabViewController else { return }
        
        switch viewModel.state {
            
        case .inspecting(_, let meadow, _, _):
        
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
        
        guard let tabViewController = tabViewController else { return }
        
        switch to {
            
        case .empty:
            
            tabViewController.viewModel.state = .empty
            
        case .inspecting(let delegate, let meadow, let item, _):
            
            switch tabViewController.viewModel.state {
                
            case .empty:
                
                tabViewController.viewModel.state = .inspector(meadow)
                
            default: break
            }
            
            guard let inspectorTabViewController = tabViewController.inspectorTabViewController, let utilitiesTabViewController = tabViewController.utilitiesTabViewController else { break }
            
            switch type(of: item) {
                
            case is CameraJib.Type:
                
                tabViewController.viewModel.state = .inspector(meadow)
                inspectorTabViewController.viewModel.state = .camera(item as! CameraJib)
                utilitiesTabViewController.viewModel.state = .empty
                
            case is Area.Type,
                 is AreaChunk.Type,
                 is AreaTile.Type,
                 is AreaNode.Type:
                
                inspectorTabViewController.viewModel.state = .area(delegate, meadow.world.areas, item as? AreaChunk, item as? AreaTile, item as? AreaNode)
                utilitiesTabViewController.viewModel.state = .area(meadow.world.areas)
                
            case is Foliage.Type,
                 is FoliageChunk.Type,
                 is FoliageTile.Type,
                 is FoliageNode.Type:
                
                inspectorTabViewController.viewModel.state = .foliage(delegate, meadow.world.foliage, item as? FoliageChunk, item as? FoliageTile, item as? FoliageNode)
                utilitiesTabViewController.viewModel.state = .foliage(meadow.world.foliage)
                
            case is Footpath.Type,
                 is FootpathChunk.Type,
                 is FootpathTile.Type,
                 is FootpathNode.Type:
                
                inspectorTabViewController.viewModel.state = .footpath(delegate, meadow.world.footpaths, item as? FootpathChunk, item as? FootpathTile, item as? FootpathNode)
                utilitiesTabViewController.viewModel.state = .footpath(meadow.world.footpaths)
                
            case is Terrain.Type,
                 is TerrainChunk.Type,
                 is TerrainTile.Type,
                 is TerrainNode<TerrainLayer>.Type,
                 is TerrainLayer.Type:
                
                inspectorTabViewController.viewModel.state = .terrain(delegate, meadow.world.terrain, item as? TerrainChunk, item as? TerrainTile, item as? TerrainNode, item as? TerrainLayer)
                utilitiesTabViewController.viewModel.state = .terrain(meadow.world.terrain)
                
            case is Water.Type,
                 is WaterChunk.Type,
                 is WaterTile.Type,
                 is WaterNode.Type:
                
                inspectorTabViewController.viewModel.state = .water(delegate, meadow.world.water, item as? WaterChunk, item as? WaterTile, item as? WaterNode)
                utilitiesTabViewController.viewModel.state = .water(meadow.world.water)
                
            case is World.Type:
                
                tabViewController.viewModel.state = .inspector(meadow)
                inspectorTabViewController.viewModel.state = .world(meadow.world)
                utilitiesTabViewController.viewModel.state = .empty
                
            case is Meadow.Type:
                
                tabViewController.viewModel.state = .inspector(meadow)
                inspectorTabViewController.viewModel.state = .scene(meadow)
                utilitiesTabViewController.viewModel.state = .empty
                
            default:
                
                inspectorTabViewController.viewModel.state = .empty
                utilitiesTabViewController.viewModel.state = .empty
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
