//
//  WaterBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 18/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class WaterBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var waterTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, _):
            
            guard let waterType = WaterType(rawValue: sender.indexOfSelectedItem) else { break }
            
            viewModel.state = .build(editor: editor, waterType: waterType)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return WaterBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
}

extension WaterBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension WaterBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
        case .build(let editor, let waterType):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            waterTypePopUp.removeAllItems()
            
            colorPaletteView.color = nil
            
            WaterType.allCases.forEach { waterType in
                
                waterTypePopUp.addItem(withTitle: waterType.name)
            }
            
            if let index = WaterType.allCases.index(of: waterType), let colorPalette = waterType.colorPalette {
                
                waterTypePopUp.selectItem(at: index)
                
                colorPaletteView.colorPalette = colorPalette
            }
        }
    }
}
