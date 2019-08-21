//
//  PropInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class PropInspectorViewController: NSViewController {
    
    @IBOutlet weak var propsBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var propBox: NSBox!
    
    @IBOutlet weak var propCount: NSTextField!
    
    @IBOutlet weak var propsHiddenButton: NSButton!
    @IBOutlet weak var propHiddenButton: NSButton!
    
    @IBOutlet weak var xPropCoordinateLabel: NSTextField!
    @IBOutlet weak var yPropCoordinateLabel: NSTextField!
    @IBOutlet weak var zPropCoordinateLabel: NSTextField!
    
    @IBOutlet weak var propTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var propListPopUp: NSPopUpButton!
    
    @IBOutlet weak var propPopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var rotationPopUp: NSPopUpButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .prop(let editor, let inspectable):
            
            switch sender {
                
            case propsHiddenButton:
                
                inspectable.props.isHidden = sender.state == .off
                
            case propHiddenButton:
                
                guard let prop = inspectable.prop else { break }
                
                prop.isHidden = sender.state == .off
                
            default: break
            }
            
            viewModel.state = .prop(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .prop(let editor, let inspectable):
            
            switch sender {
                
            case colorPalettePopUp:
                
                guard let prop = inspectable.prop, let colorPalette = ArtDirector.shared?.palettes.children[sender.indexOfSelectedItem] else { break }
                
                prop.colorPalette = colorPalette
                
            default: break
            }
            
            viewModel.state = .prop(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return PropInspectorStateObserver(initialState: .empty)
    }()
}

extension PropInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension PropInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .prop(_, let inspectable):
                
                self.propCount.integerValue = inspectable.props.totalChildren
                self.propsHiddenButton.state = (inspectable.props.isHidden ? .off : .on)
                
                self.nodeBox.isHidden = true
                self.propBox.isHidden = true
                
                if let prop = inspectable.prop {
                    
                    self.nodeBox.isHidden = inspectable.props.isHidden
                    self.propBox.isHidden = inspectable.props.isHidden || prop.isHidden
                    
                    self.propHiddenButton.state = (prop.isHidden ? .off : .on)
                    
                    self.xPropCoordinateLabel.integerValue = prop.footprint.coordinate.x
                    self.yPropCoordinateLabel.integerValue = prop.footprint.coordinate.y
                    self.zPropCoordinateLabel.integerValue = prop.footprint.coordinate.z
                    
                    self.propTypePopUp.removeAllItems()
                    self.propListPopUp.removeAllItems()
                    self.propPopUp.removeAllItems()
                    self.colorPalettePopUp.removeAllItems()
                    self.rotationPopUp.removeAllItems()
                    
                    self.propTypePopUp.isEnabled = false
                    self.propListPopUp.isEnabled = false
                    self.propPopUp.isEnabled = false
                    self.rotationPopUp.isEnabled = false
                    
                    self.propTypePopUp.addItem(withTitle: prop.prototype.type.name)
                    
                    let propList = PropsMaster.shared?.list(prop: prop.prototype)
                    
                    if let propList = propList {
                        
                        self.propListPopUp.addItem(withTitle: propList.name)
                    }
                    
                    self.propPopUp.addItem(withTitle: prop.prototype.name)
                    
                    ArtDirector.shared?.palettes.children.forEach { palette in
                        
                        self.colorPalettePopUp.addItem(withTitle: palette.name)
                    }
                    
                    if let colorPalette = prop.colorPalette, let index = ArtDirector.shared?.palettes.children.index(of: colorPalette) {
                        
                        self.colorPalettePopUp.selectItem(at: index)
                        
                        self.colorPaletteView.colorPalette = colorPalette
                    }
                    else {
                        
                        self.colorPaletteView.colorPalette = nil
                    }
                    
                    self.rotationPopUp.addItem(withTitle: prop.footprint.rotation.description)
                }
                
            default: break
            }
        }
    }
}
