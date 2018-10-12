//
//  TerrainPaintUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class TerrainPaintUtilitiesViewController: NSViewController {

    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPalettePrimary: NSBox!
    @IBOutlet weak var colorPaletteSecondary: NSBox!
    @IBOutlet weak var colorPaletteTertiary: NSBox!
    @IBOutlet weak var colorPaletteQuaternary: NSBox!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
     
        switch viewModel.state {
            
        case .paint(let meadow, let terrainType, let toolType):
            
            switch sender {
                
            case terrainTypePopUp:
                
                guard let selectedTerrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .paint(meadow: meadow, terrainType: selectedTerrainType, toolType: toolType)
                
            case toolTypePopUp:
                
                guard let selectedToolType = ToolType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .paint(meadow: meadow, terrainType: terrainType, toolType: selectedToolType)
                
            default: break
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainPaintUtilitiesViewModel(initialState: .empty(meadow: nil))
    }()
    
    var cursorModelCallbackReference: UUID?
}

extension TerrainPaintUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainPaintUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let meadow):
            
            guard let meadow = meadow else { break }
            
            meadow.input.cursorModel.tracksIdleEvents = false
            
            if let reference = cursorModelCallbackReference {
            
                meadow.input.cursorModel.unsubscribe(reference)
            }
            
        case .paint(let meadow, let terrainType, let toolType):
            
            meadow.input.cursorModel.tracksIdleEvents = true
            
            cursorModelCallbackReference = meadow.input.cursorModel.subscribe(stateDidChange(from:to:))
            
            terrainTypePopUp.removeAllItems()
            toolTypePopUp.removeAllItems()
            
            colorPalettePrimary.fillColor = NSColor.white
            colorPaletteSecondary.fillColor = NSColor.white
            colorPaletteTertiary.fillColor = NSColor.white
            colorPaletteQuaternary.fillColor = NSColor.white
            
            TerrainType.allCases.forEach { terrainType in
                
                terrainTypePopUp.addItem(withTitle: terrainType.name)
            }
            
            toolTypePopUp.addItem(withTitle: "Corner")
            toolTypePopUp.addItem(withTitle: "Tile")
            
            toolTypePopUp.selectItem(at: toolType.rawValue)
            
            if let index = TerrainType.allCases.index(of: terrainType), let colorPalette = terrainType.colorPalette {
                
                terrainTypePopUp.selectItem(at: index)
                
                colorPalettePrimary.fillColor = colorPalette.primary.color
                colorPaletteSecondary.fillColor = colorPalette.secondary.color
                colorPaletteTertiary.fillColor = colorPalette.tertiary.color
                colorPaletteQuaternary.fillColor = colorPalette.quaternary.color
            }
        }
    }
}

extension TerrainPaintUtilitiesViewController: CursorModelObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .paint(let meadow, let terrainType, let toolType):
            
            switch to {
                
            case .idle(let position):
                
                print("paint - idle: \(position)")
                
            case .down(let position, let inputType):
                
                print("paint - down: \(inputType) \(position)")
                
            case .tracking(let position, let inputType, let startPosition):
                
                print("paint - tracking: \(inputType) \(startPosition) -> \(position)")
                
            case .up(let position, let inputType, let startPosition):
                
                print("paint - up: \(inputType) \(startPosition) -> \(position)")
            }
            
        default: break
        }
    }
}
