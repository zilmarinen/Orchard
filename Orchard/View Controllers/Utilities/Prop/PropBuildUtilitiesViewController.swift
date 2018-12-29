//
//  PropBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class PropBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var propPopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, var utility):
            
            switch sender {
                
            case propPopUp:
                
                guard let prop = PropsMaster.shared?.props.child(at: sender.indexOfSelectedItem) else { break }
                
                utility.prop = prop
                
            case colorPalettePopUp:
                
                guard let colorPalette = ArtDirector.shared?.palettes.child(at: sender.indexOfSelectedItem) else { break }
                
                utility.colorPalette = colorPalette
                
            default: break
            }
         
            viewModel.state = .build(editor: editor, utility: utility)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return PropBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var cursorCallbackReference: SceneView.Cursor.CallbackReference?
}

extension PropBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension PropBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let reference = cursorCallbackReference {
                
                editor.meadow.input.cursor.unsubscribe(reference)
            }
            
        case .build(let editor, let utility):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))
            
            propPopUp.removeAllItems()
            colorPalettePopUp.removeAllItems()
            
            colorPaletteView.color = nil
            
            if let propCount = PropsMaster.shared?.props.totalChildren {
                
                for index in 0..<propCount {
                    
                    if let prop = PropsMaster.shared?.props.child(at: index) {
                        
                        propPopUp.addItem(withTitle: prop.name)
                    }
                }
            }
            
            if let index = PropsMaster.shared?.props.index(of: utility.prop) {
                
                propPopUp.selectItem(at: index)
            }
            
            if let paletteCount = ArtDirector.shared?.palettes.totalChildren {
                
                for index in 0..<paletteCount {
                    
                    if let palette = ArtDirector.shared?.palettes.child(at: index) {
                        
                        colorPalettePopUp.addItem(withTitle: palette.name)
                    }
                }
            }
            
            if let index = ArtDirector.shared?.palettes.index(of: utility.colorPalette) {
                
                colorPalettePopUp.selectItem(at: index)
                
                colorPaletteView.colorPalette = utility.colorPalette
            }
        }
    }
}

extension PropBuildUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .build(let editor, let utility):
            
            print("")
            
        default: break
        }
    }
}
