//
//  CameraInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 21/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class CameraInspectorViewController: NSViewController {
    
    @IBOutlet weak var xPositionLabel: NSTextField!
    @IBOutlet weak var yPositionLabel: NSTextField!
    @IBOutlet weak var zPositionLabel: NSTextField!
    
    @IBOutlet weak var xRotationLabel: NSTextField!
    @IBOutlet weak var yRotationLabel: NSTextField!
    @IBOutlet weak var zRotationLabel: NSTextField!
    
    @IBAction func textField(_ sender: NSTextField) {
        
        switch viewModel.state {
            
        case .inspecting(let cameraJib):
        
            switch sender {
            
            case xPositionLabel,
                 yPositionLabel,
                 zPositionLabel:
            
                cameraJib.position = SCNVector3(x: CGFloat(xPositionLabel.floatValue), y: CGFloat(yPositionLabel.floatValue), z: CGFloat(zPositionLabel.floatValue))
            
            default:
            
                cameraJib.eulerAngles = SCNVector3(x: CGFloat(xRotationLabel.floatValue), y: CGFloat(yRotationLabel.floatValue), z: CGFloat(zRotationLabel.floatValue))
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return CameraInspectorViewModel(initialState: .empty)
    }()
}

extension CameraInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension CameraInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {

        switch to {
            
        case .inspecting(let cameraJib):
            
            xPositionLabel.stringValue = "\(cameraJib.position.x)"
            yPositionLabel.stringValue = "\(cameraJib.position.y)"
            zPositionLabel.stringValue = "\(cameraJib.position.z)"
            
            xRotationLabel.stringValue = "\(cameraJib.eulerAngles.x)"
            yRotationLabel.stringValue = "\(cameraJib.eulerAngles.y)"
            zRotationLabel.stringValue = "\(cameraJib.eulerAngles.z)"
            
        default: break
        }
    }
}
