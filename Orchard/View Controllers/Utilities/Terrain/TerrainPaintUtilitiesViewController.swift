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
            
        case .inspecting(let terrain, let terrainType, let toolType):
            
            switch sender {
                
            case terrainTypePopUp:
                
                guard let selectedTerrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .inspecting(terrain, selectedTerrainType, toolType)
                
            case toolTypePopUp:
                
                guard let selectedToolType = ToolType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .inspecting(terrain, terrainType, selectedToolType)
                
            default: break
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainPaintUtilitiesViewModel(initialState: .empty)
    }()
}

extension TerrainPaintUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension TerrainPaintUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(_, let terrainType, let toolType):
            
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
            
            if let terrainType = terrainType, let index = TerrainType.allCases.index(of: terrainType), let colorPalette = terrainType.colorPalette {
                
                terrainTypePopUp.selectItem(at: index)
                
                colorPalettePrimary.fillColor = colorPalette.primary.color
                colorPaletteSecondary.fillColor = colorPalette.secondary.color
                colorPaletteTertiary.fillColor = colorPalette.tertiary.color
                colorPaletteQuaternary.fillColor = colorPalette.quaternary.color
            }
            
        default: break
        }
    }
}
