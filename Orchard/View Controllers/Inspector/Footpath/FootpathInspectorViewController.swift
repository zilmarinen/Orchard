//
//  FootpathInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class FootpathInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkCount: NSTextField!
    
    @IBOutlet weak var xCoordinateLabel: NSTextField!
    @IBOutlet weak var yCoordinateLabel: NSTextField!
    @IBOutlet weak var zCoordinateLabel: NSTextField!
    
    @IBOutlet weak var xSizeLabel: NSTextField!
    @IBOutlet weak var ySizeLabel: NSTextField!
    @IBOutlet weak var zSizeLabel: NSTextField!
    
    @IBOutlet weak var footpathTypePopUp: NSPopUpButton!
    @IBOutlet weak var slopeEdgePopUp: NSPopUpButton!
    
    @IBOutlet weak var slopeCheckBox: NSButton!
    
    @IBOutlet weak var nodeBox: NSBox!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .inspecting(let footpath, let footpathNode):
            
            guard let footpathNode = footpathNode else { return }
            
            switch sender.state {
                
            case .on:
                
                let edge = GridEdge(rawValue: slopeEdgePopUp.indexOfSelectedItem)!
                
                footpathNode.slope = edge
                
            default:
                
                footpathNode.slope = nil
            }
            
            viewModel.state = .inspecting(footpath, footpathNode)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let footpath, let footpathNode):
            
            guard let footpathNode = footpathNode else { return }
            
            switch sender {
                
            case footpathTypePopUp:
                
                let footpathType = footpath.availableFootpathTypes[sender.indexOfSelectedItem]
                
                footpathNode.footpathType = footpathType
                
            case slopeEdgePopUp:
                
                let edge = GridEdge(rawValue: sender.indexOfSelectedItem)!
                
                footpathNode.slope = edge
                
            default: break
            }
            
            viewModel.state = .inspecting(footpath, footpathNode)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return FootpathInspectorViewModel(initialState: .empty)
    }()
}

extension FootpathInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension FootpathInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let footpath, let footpathNode):
            
            chunkCount.stringValue = "\(footpath.totalChildren)"
            
            footpathTypePopUp.removeAllItems()
            slopeEdgePopUp.removeAllItems()
            
            nodeBox.isHidden = true
            
            slopeEdgePopUp.isEnabled = false
            
            slopeEdgePopUp.addItem(withTitle: "North")
            slopeEdgePopUp.addItem(withTitle: "East")
            slopeEdgePopUp.addItem(withTitle: "South")
            slopeEdgePopUp.addItem(withTitle: "West")
            
            guard let footpathNode = footpathNode else { break }
                
            nodeBox.isHidden = false
            
            footpath.availableFootpathTypes.forEach { footpathType in
                
                footpathTypePopUp.addItem(withTitle: footpathType.name)
            }
            
            if let footpathType = footpathNode.footpathType {
            
                footpathTypePopUp.selectItem(at: footpath.availableFootpathTypes.index(of: footpathType)!)
            }
            
            xCoordinateLabel.stringValue = "\(footpathNode.volume.coordinate.x)"
            yCoordinateLabel.stringValue = "\(footpathNode.volume.coordinate.y)"
            zCoordinateLabel.stringValue = "\(footpathNode.volume.coordinate.z)"
            xSizeLabel.stringValue = "\(footpathNode.volume.size.width)"
            ySizeLabel.stringValue = "\(footpathNode.volume.size.height)"
            zSizeLabel.stringValue = "\(footpathNode.volume.size.depth)"
            
            slopeCheckBox.state = (footpathNode.slope != nil ? .on : .off)
            
            if let slope = footpathNode.slope {
                
                slopeEdgePopUp.selectItem(at: slope.rawValue)
                slopeEdgePopUp.isEnabled = true
            }
            
        default: break
        }
    }
}
