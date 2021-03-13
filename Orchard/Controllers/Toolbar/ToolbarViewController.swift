//
//  ToolbarViewController.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

@objc class ToolbarViewController: NSViewController {
    
    @IBOutlet weak var sceneButton: NSButton!
    @IBOutlet weak var surfaceButton: NSButton!
    
    @IBOutlet var surfaceMenu: NSMenu!
    @IBOutlet weak var surfaceInspectorItem: NSMenuItem!
    @IBOutlet weak var surfaceMaterialItem: NSMenuItem!
    @IBOutlet weak var surfaceElevationItem: NSMenuItem!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let event = NSApplication.shared.currentEvent else { return }
        
        switch sender {
        
        case sceneButton:
            
            coordinator?.toggle(inspector: .scene, with: nil)
        
        case surfaceButton:
            
            NSMenu.popUpContextMenu(surfaceMenu, with: event, for: sender)
            
        default: break
        }
    }
    
    @IBAction func menuItem(_ sender: NSMenuItem) {
        
        switch sender {
        
        case surfaceInspectorItem:
            
            guard let tile = coordinator?.editor?.surface.tiles.first else { return }
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.inspector(tile: tile))
            
        case surfaceMaterialItem:
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.material)
            
        case surfaceElevationItem:
            
            coordinator?.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.elevation)
            
        default: break
        }
    }
    
    weak var coordinator: ToolbarCoordinator?
}
