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
                
            default: break
            }
         
            viewModel.state = .build(editor: editor, utility: utility)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return PropBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
}

extension PropBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension PropBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            default: break
            }
        }
    }
}
