//
//  TerrainBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow

class TerrainBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPalettePrimary: NSBox!
    @IBOutlet weak var colorPaletteSecondary: NSBox!
    @IBOutlet weak var colorPaletteTertiary: NSBox!
    @IBOutlet weak var colorPaletteQuaternary: NSBox!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, let grid, _):
            
            guard let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
            
            viewModel.state = .build(editor: editor, grid: grid, terrainType: terrainType)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
}

extension TerrainBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension TerrainBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            print("empty")
            
        case .build(_, _, let terrainType):
            
            print("build")
            
            terrainTypePopUp.removeAllItems()
            
            colorPalettePrimary.fillColor = NSColor.white
            colorPaletteSecondary.fillColor = NSColor.white
            colorPaletteTertiary.fillColor = NSColor.white
            colorPaletteQuaternary.fillColor = NSColor.white
            
            TerrainType.allCases.forEach { terrainType in
                
                terrainTypePopUp.addItem(withTitle: terrainType.name)
            }
            
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
