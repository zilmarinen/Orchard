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
    @IBOutlet weak var propBox: NSBox!
    
    @IBOutlet weak var propCount: NSTextField!
    
    @IBOutlet weak var propsHiddenButton: NSButton!
    @IBOutlet weak var propHiddenButton: NSButton!
    
    @IBOutlet weak var xPropCoordinateLabel: NSTextField!
    @IBOutlet weak var yPropCoordinateLabel: NSTextField!
    @IBOutlet weak var zPropCoordinateLabel: NSTextField!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .prop(let editor, let inspectable):
            
            switch sender {
                
            case propsHiddenButton:
                
                inspectable.props.isHidden = sender.state == .off
                
            case propHiddenButton:
                
                guard let propNode = inspectable.propNode else { break }
                
                propNode.isHidden = sender.state == .off
                
            default: break
            }
            
            viewModel.state = .prop(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return PropInspectorViewModel(initialState: .empty)
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
        
        switch to {
            
        case .prop(_, let inspectable):
            
            propCount.integerValue = inspectable.props.totalChildren
            propsHiddenButton.state = (inspectable.props.isHidden ? .off : .on)
            
            propBox.isHidden = true
            
            if let propNode = inspectable.propNode {
                
                propBox.isHidden = propNode.isHidden
                
                xPropCoordinateLabel.integerValue = propNode.footprint.coordinate.x
                yPropCoordinateLabel.integerValue = propNode.footprint.coordinate.y
                zPropCoordinateLabel.integerValue = propNode.footprint.coordinate.z
            }
            
        default: break
        }
    }
}
