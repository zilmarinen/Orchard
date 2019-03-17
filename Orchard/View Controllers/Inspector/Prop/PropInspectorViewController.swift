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
                
                guard let prop = inspectable.prop else { break }
                
                prop.isHidden = sender.state == .off
                
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
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .prop(_, let inspectable):
                
                self.propCount.integerValue = inspectable.props.totalChildren
                self.propsHiddenButton.state = (inspectable.props.isHidden ? .off : .on)
                
                self.propBox.isHidden = true
                
                if let prop = inspectable.prop {
                    
                    self.propBox.isHidden = prop.isHidden
                    
                    self.xPropCoordinateLabel.integerValue = prop.footprint.coordinate.x
                    self.yPropCoordinateLabel.integerValue = prop.footprint.coordinate.y
                    self.zPropCoordinateLabel.integerValue = prop.footprint.coordinate.z
                }
                
            default: break
            }
        }
    }
}
