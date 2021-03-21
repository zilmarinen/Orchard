//
//  ToolbarViewController.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

@objc class ToolbarViewController: NSViewController {
    
    @IBOutlet weak var buildingButton: NSButton!
    @IBOutlet weak var foliageButton: NSButton!
    @IBOutlet weak var footpathButton: NSButton!
    @IBOutlet weak var sceneButton: NSButton!
    @IBOutlet weak var portalButton: NSButton!
    @IBOutlet weak var surfaceButton: NSButton!
    @IBOutlet weak var waterButton: NSButton!
    
    @IBOutlet var buildingMenu: NSMenu!
    @IBOutlet weak var buildingInspectorItem: NSMenuItem!
    @IBOutlet weak var buildingBuildItem: NSMenuItem!
    
    @IBOutlet var surfaceMenu: NSMenu!
    @IBOutlet weak var surfaceInspectorItem: NSMenuItem!
    @IBOutlet weak var surfaceMaterialItem: NSMenuItem!
    @IBOutlet weak var surfaceElevationItem: NSMenuItem!
    
    @IBOutlet var foliageMenu: NSMenu!
    @IBOutlet weak var foliageInspectorItem: NSMenuItem!
    @IBOutlet weak var foliagePlantItem: NSMenuItem!
    
    @IBOutlet var footpathMenu: NSMenu!
    @IBOutlet weak var footpathInspectorItem: NSMenuItem!
    @IBOutlet weak var footpathMaterialItem: NSMenuItem!
    
    @IBOutlet var portalMenu: NSMenu!
    @IBOutlet weak var portalInspectorItem: NSMenuItem!
    @IBOutlet weak var portalBuildItem: NSMenuItem!
    
    @IBOutlet var waterMenu: NSMenu!
    @IBOutlet weak var waterInspectorItem: NSMenuItem!
    @IBOutlet weak var waterMaterialItem: NSMenuItem!
    @IBOutlet weak var waterElevationItem: NSMenuItem!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let event = NSApplication.shared.currentEvent else { return }
        
        switch sender {
        
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
        
        case surfaceButton:
            
            NSMenu.popUpContextMenu(surfaceMenu, with: event, for: sender)
            
        case waterButton:
            
            NSMenu.popUpContextMenu(waterMenu, with: event, for: sender)
            
        default: break
        }
    }
    
    @IBAction func menuItem(_ sender: NSMenuItem) {
        
        switch sender {
        
        case buildingInspectorItem:
            
            guard let node = coordinator?.editor?.buildings.buildings.first else { return }
            
            coordinator?.toggle(inspector: .building, with: BuildingUtilityCoordinator.ViewState.inspector(node: node))
            
        case buildingBuildItem:
            
            coordinator?.toggle(inspector: .building, with: BuildingUtilityCoordinator.ViewState.build)
        
        case foliageInspectorItem:
            
            guard let node = coordinator?.editor?.foliage.vegetation.first else { return }
            
            coordinator?.toggle(inspector: .foliage, with: FoliageUtilityCoordinator.ViewState.inspector(node: node))
            
        case foliagePlantItem:
            
            coordinator?.toggle(inspector: .foliage, with: FoliageUtilityCoordinator.ViewState.plant)
            
        case footpathInspectorItem:
            
            guard let node = coordinator?.editor?.footpath.tiles.first else { return }
            
            coordinator?.toggle(inspector: .footpath, with: FootpathUtilityCoordinator.ViewState.inspector(node: node))
            
        case footpathMaterialItem:
            
            coordinator?.toggle(inspector: .footpath, with: FootpathUtilityCoordinator.ViewState.material)
            
        case portalInspectorItem:
            
            guard let node = coordinator?.editor?.portals.portals.first else { return }
            
            coordinator?.toggle(inspector: .portal, with: PortalUtilityCoordinator.ViewState.inspector(node: node))
            
        case portalBuildItem:
            
            coordinator?.toggle(inspector: .portal, with: PortalUtilityCoordinator.ViewState.build)
        
        case surfaceInspectorItem:
            
            guard let node = coordinator?.editor?.surface.tiles.first else { return }
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.inspector(node: node))
            
        case surfaceMaterialItem:
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.material)
            
        case surfaceElevationItem:
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.elevation)
            
        case waterInspectorItem:
            
            guard let node = coordinator?.editor?.water.tiles.first else { return }
            
            coordinator?.toggle(inspector: .water, with: WaterUtilityCoordinator.ViewState.inspector(node: node))
            
        case waterMaterialItem:
            
            coordinator?.toggle(inspector: .water, with: WaterUtilityCoordinator.ViewState.material)
            
        case waterElevationItem:
            
            coordinator?.toggle(inspector: .water, with: WaterUtilityCoordinator.ViewState.elevation)
            
        default: break
        }
    }
    
    weak var coordinator: ToolbarCoordinator?
}

extension ToolbarViewController {
    
    override func toggle(inspector: InspectorTabViewCoordinator.Tab, with object: Any? = nil) {
        
        buildingButton.contentTintColor = nil
        foliageButton.contentTintColor = nil
        footpathButton.contentTintColor = nil
        sceneButton.contentTintColor = nil
        portalButton.contentTintColor = nil
        surfaceButton.contentTintColor = nil
        
        switch inspector {
        
        case .building: buildingButton.contentTintColor = .systemPink
        case .foliage: foliageButton.contentTintColor = .systemPink
        case .footpath: footpathButton.contentTintColor = .systemPink
        case .portal: portalButton.contentTintColor = .systemPink
        case .scene: sceneButton.contentTintColor = .systemPink
        case .surface: surfaceButton.contentTintColor = .systemPink
            
        default: break
        }
    }
}
