//
//  ToolbarViewController.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

@objc class ToolbarViewController: NSViewController {
    
    @IBOutlet weak var actorButton: NSButton!
    @IBOutlet weak var bridgeButton: NSButton!
    @IBOutlet weak var buildingButton: NSButton!
    @IBOutlet weak var foliageButton: NSButton!
    @IBOutlet weak var footpathButton: NSButton!
    @IBOutlet weak var portalButton: NSButton!
    @IBOutlet weak var sceneButton: NSButton!
    @IBOutlet weak var stairsButton: NSButton!
    @IBOutlet weak var surfaceButton: NSButton!
    @IBOutlet weak var wallButton: NSButton!
    @IBOutlet weak var waterButton: NSButton!
    
    @IBOutlet var actorMenu: NSMenu!
    @IBOutlet weak var actorInspectorItem: NSMenuItem!
    @IBOutlet weak var actorPlacementItem: NSMenuItem!
    
    @IBOutlet var bridgeMenu: NSMenu!
    @IBOutlet weak var bridgeInspectorItem: NSMenuItem!
    @IBOutlet weak var bridgeBuildItem: NSMenuItem!
    
    @IBOutlet var buildingMenu: NSMenu!
    @IBOutlet weak var buildingInspectorItem: NSMenuItem!
    @IBOutlet weak var buildingBuildItem: NSMenuItem!
    
    @IBOutlet var stairsMenu: NSMenu!
    @IBOutlet weak var stairsInspectorItem: NSMenuItem!
    @IBOutlet weak var stairsBuildItem: NSMenuItem!
    
    @IBOutlet var foliageMenu: NSMenu!
    @IBOutlet weak var foliageInspectorItem: NSMenuItem!
    @IBOutlet weak var foliagePlantItem: NSMenuItem!
    
    @IBOutlet var footpathMenu: NSMenu!
    @IBOutlet weak var footpathInspectorItem: NSMenuItem!
    @IBOutlet weak var footpathMaterialItem: NSMenuItem!
    
    @IBOutlet var portalMenu: NSMenu!
    @IBOutlet weak var portalInspectorItem: NSMenuItem!
    @IBOutlet weak var portalBuildItem: NSMenuItem!
    
    @IBOutlet var surfaceMenu: NSMenu!
    @IBOutlet weak var surfaceInspectorItem: NSMenuItem!
    @IBOutlet weak var surfaceMaterialItem: NSMenuItem!
    @IBOutlet weak var surfaceElevationItem: NSMenuItem!
    @IBOutlet weak var surfaceEdgeItem: NSMenuItem!
    
    @IBOutlet var wallMenu: NSMenu!
    @IBOutlet weak var wallInspectorItem: NSMenuItem!
    @IBOutlet weak var wallBuildItem: NSMenuItem!
    
    @IBOutlet var waterMenu: NSMenu!
    @IBOutlet weak var waterInspectorItem: NSMenuItem!
    @IBOutlet weak var waterMaterialItem: NSMenuItem!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let event = NSApplication.shared.currentEvent else { return }
        
        switch sender {
        
        case actorButton:
            
            NSMenu.popUpContextMenu(actorMenu, with: event, for: sender)
            
        case bridgeButton:
            
            NSMenu.popUpContextMenu(bridgeMenu, with: event, for: sender)
        
        case buildingButton:
            
            NSMenu.popUpContextMenu(buildingMenu, with: event, for: sender)
            
        case foliageButton:
            
            NSMenu.popUpContextMenu(foliageMenu, with: event, for: sender)
            
        case footpathButton:
            
            NSMenu.popUpContextMenu(footpathMenu, with: event, for: sender)
            
        case portalButton:
            
            NSMenu.popUpContextMenu(portalMenu, with: event, for: sender)
        
        case sceneButton:
            
            coordinator?.toggle(inspector: .scene, with: nil)
            
        case stairsButton:
            
            NSMenu.popUpContextMenu(stairsMenu, with: event, for: sender)
        
        case surfaceButton:
            
            NSMenu.popUpContextMenu(surfaceMenu, with: event, for: sender)
            
        case wallButton:
            
            NSMenu.popUpContextMenu(wallMenu, with: event, for: sender)
            
        case waterButton:
            
            NSMenu.popUpContextMenu(waterMenu, with: event, for: sender)
            
        default: break
        }
    }
    
    @IBAction func menuItem(_ sender: NSMenuItem) {
        
        switch sender {
        
        case actorInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.actors.npcs.first else { return }
            
            coordinator?.toggle(inspector: .actor, with: ActorUtilityCoordinator.ViewState.inspector(node: node))
            
        case actorPlacementItem:
            
            coordinator?.toggle(inspector: .actor, with: ActorUtilityCoordinator.ViewState.placement)
            
        case bridgeInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.bridges.chunks.first else { return }
            
            coordinator?.toggle(inspector: .bridge, with: BridgeUtilityCoordinator.ViewState.inspector(node: node))
            
        case bridgeBuildItem:
            
            coordinator?.toggle(inspector: .bridge, with: BridgeUtilityCoordinator.ViewState.build)
            
        case buildingInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.buildings.chunks.first else { return }
            
            coordinator?.toggle(inspector: .building, with: BuildingUtilityCoordinator.ViewState.inspector(node: node))
            
        case buildingBuildItem:
            
            coordinator?.toggle(inspector: .building, with: BuildingUtilityCoordinator.ViewState.build)
        
        case foliageInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.foliage.chunks.first else { return }
            
            coordinator?.toggle(inspector: .foliage, with: FoliageUtilityCoordinator.ViewState.inspector(node: node))
            
        case foliagePlantItem:
            
            coordinator?.toggle(inspector: .foliage, with: FoliageUtilityCoordinator.ViewState.plant)
            
        case footpathInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.footpath.tiles.first else { return }
            
            coordinator?.toggle(inspector: .footpath, with: FootpathUtilityCoordinator.ViewState.inspector(node: node))
            
        case footpathMaterialItem:
            
            coordinator?.toggle(inspector: .footpath, with: FootpathUtilityCoordinator.ViewState.material)
            
        case portalInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.portals.chunks.first else { return }
            
            coordinator?.toggle(inspector: .portal, with: PortalUtilityCoordinator.ViewState.inspector(node: node))
            
        case portalBuildItem:
            
            coordinator?.toggle(inspector: .portal, with: PortalUtilityCoordinator.ViewState.build)
            
        case stairsInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.stairs.chunks.first else { return }
            
            coordinator?.toggle(inspector: .stairs, with: StairsUtilityCoordinator.ViewState.inspector(node: node))
            
        case stairsBuildItem:
            
            coordinator?.toggle(inspector: .stairs, with: StairsUtilityCoordinator.ViewState.build)
        
        case surfaceInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.surface.tiles.first else { return }
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.inspector(node: node))
            
        case surfaceMaterialItem:
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.material)
            
        case surfaceElevationItem:
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.elevation)
            
        case surfaceEdgeItem:
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.edge)
            
        case wallInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.walls.tiles.first else { return }
            
            coordinator?.toggle(inspector: .wall, with: WallUtilityCoordinator.ViewState.inspector(node: node))
            
        case wallBuildItem:
            
            coordinator?.toggle(inspector: .wall, with: WallUtilityCoordinator.ViewState.build)
            
        case waterInspectorItem:
            
            guard let node = coordinator?.editor?.harvest.water.tiles.first else { return }
            
            coordinator?.toggle(inspector: .water, with: WaterUtilityCoordinator.ViewState.inspector(node: node))
            
        case waterMaterialItem:
            
            coordinator?.toggle(inspector: .water, with: WaterUtilityCoordinator.ViewState.material)
            
        default: break
        }
    }
    
    weak var coordinator: ToolbarCoordinator?
}

extension ToolbarViewController {
    
    override func toggle(inspector: InspectorTabViewCoordinator.Tab, with object: Any? = nil) {
        
        actorButton.contentTintColor = nil
        bridgeButton.contentTintColor = nil
        buildingButton.contentTintColor = nil
        foliageButton.contentTintColor = nil
        footpathButton.contentTintColor = nil
        portalButton.contentTintColor = nil
        sceneButton.contentTintColor = nil
        stairsButton.contentTintColor = nil
        surfaceButton.contentTintColor = nil
        wallButton.contentTintColor = nil
        waterButton.contentTintColor = nil
        
        switch inspector {
        
        case .actor: actorButton.contentTintColor = .systemPink
        case .bridge: bridgeButton.contentTintColor = .systemPink
        case .building: buildingButton.contentTintColor = .systemPink
        case .foliage: foliageButton.contentTintColor = .systemPink
        case .footpath: footpathButton.contentTintColor = .systemPink
        case .portal: portalButton.contentTintColor = .systemPink
        case .scene: sceneButton.contentTintColor = .systemPink
        case .stairs: stairsButton.contentTintColor = .systemPink
        case .surface: surfaceButton.contentTintColor = .systemPink
        case .wall: wallButton.contentTintColor = .systemPink
        case .water: waterButton.contentTintColor = .systemPink
            
        default: break
        }
    }
}
