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
    
    @IBOutlet weak var selectedProjectionTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var zNearLabel: NSTextField!
    @IBOutlet weak var zFarLabel: NSTextField!
    @IBOutlet weak var fovLabel: NSTextField!
    @IBOutlet weak var scaleLabel: NSTextField!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let cameraJib):
            
            guard let camera = cameraJib.camera else { break }
            
            camera.usesOrthographicProjection = sender.indexOfSelectedItem == 0
            
            viewModel.state = .inspecting(cameraJib)
            
        default: break
        }
    }
    
    @IBAction func textField(_ sender: NSTextField) {
        
        switch viewModel.state {
            
        case .inspecting(let cameraJib):
            
            guard let camera = cameraJib.camera else { break }
            
            switch sender {
            
            case xPositionLabel,
                 yPositionLabel,
                 zPositionLabel:
            
                cameraJib.position = SCNVector3(x: CGFloat(xPositionLabel.floatValue), y: CGFloat(yPositionLabel.floatValue), z: CGFloat(zPositionLabel.floatValue))
            
            case xRotationLabel,
                 yRotationLabel,
                 zRotationLabel:
            
                cameraJib.eulerAngles = SCNVector3(x: CGFloat(xRotationLabel.floatValue), y: CGFloat(yRotationLabel.floatValue), z: CGFloat(zRotationLabel.floatValue))
                
            case zNearLabel:
                
                camera.zNear = zNearLabel.doubleValue
                
            case zFarLabel:
                
                camera.zFar = zFarLabel.doubleValue
                
            case fovLabel:
                
                camera.fieldOfView = MDWFloat(fovLabel.floatValue)
                
            case scaleLabel:
                
                camera.orthographicScale = scaleLabel.doubleValue
                
            default: break
            }
            
            viewModel.state = .inspecting(cameraJib)
            
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
            
            guard let camera = cameraJib.camera else { break }
            
            selectedProjectionTypePopUp.removeAllItems()
            
            selectedProjectionTypePopUp.addItem(withTitle: "Orthographic")
            selectedProjectionTypePopUp.addItem(withTitle: "Perspective")
            
            xPositionLabel.floatValue = Float(cameraJib.position.x)
            yPositionLabel.floatValue = Float(cameraJib.position.y)
            zPositionLabel.floatValue = Float(cameraJib.position.z)
            
            xRotationLabel.floatValue = Float(cameraJib.eulerAngles.x)
            yRotationLabel.floatValue = Float(cameraJib.eulerAngles.y)
            zRotationLabel.floatValue = Float(cameraJib.eulerAngles.z)
            
            selectedProjectionTypePopUp.selectItem(at: (camera.usesOrthographicProjection ? 0 : 1))
            
            zNearLabel.doubleValue = camera.zNear
            zFarLabel.doubleValue = camera.zFar
            fovLabel.floatValue = Float(camera.fieldOfView)
            scaleLabel.doubleValue = camera.orthographicScale
            
            fovLabel.isEnabled = !camera.usesOrthographicProjection
            scaleLabel.isEnabled = camera.usesOrthographicProjection
            
        default: break
        }
    }
}
