//
//  TerrainTerraformUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class TerrainTerraformUtilitiesViewController: NSViewController {

    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var depthTextField: NSTextField!
    
    @IBOutlet weak var widthStepper: NSStepper!
    @IBOutlet weak var depthStepper: NSStepper!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .terraform(let editor, let tool):
            
            guard let toolType = ToolType(rawValue: sender.indexOfSelectedItem) else { break }
            
            viewModel.state = .terraform(editor: editor, tool: (toolType: toolType, reticule: tool.reticule))
            
        default: break
        }
    }
    
    @IBAction func stepper(_ sender: NSStepper) {
        
        switch viewModel.state {
            
        case .terraform(let editor, var tool):
            
            switch sender {
                
            case widthStepper:
                
                tool.reticule.width = widthStepper.integerValue
                
            case depthStepper:
                
                tool.reticule.depth = depthStepper.integerValue
                
            default: break
            }
            
            viewModel.state = .terraform(editor: editor, tool: tool)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainTerraformUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var graticuleIdentifier: SceneView.Graticule.CallbackReference?
}

extension TerrainTerraformUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainTerraformUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let graticuleIdentifier = graticuleIdentifier {
                
                editor.meadow.input.graticule.unsubscribe(graticuleIdentifier)
            }
            
            graticuleIdentifier = nil
            
        case .terraform(let editor, let tool):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            if graticuleIdentifier == nil {
                
                graticuleIdentifier = editor.meadow.input.graticule.subscribe(stateDidChange(from:to:))
            }
            
            toolTypePopUp.removeAllItems()
            
            toolTypePopUp.addItem(withTitle: "Corner")
            toolTypePopUp.addItem(withTitle: "Edge")
            toolTypePopUp.addItem(withTitle: "Tile")
            
            toolTypePopUp.selectItem(at: tool.toolType.rawValue)
            
            widthStepper.maxValue = 10
            widthStepper.minValue = 1
            widthStepper.integerValue = tool.reticule.width
            widthStepper.isEnabled = tool.toolType == ToolType.tile
                
            depthStepper.maxValue = 10
            depthStepper.minValue = 1
            depthStepper.integerValue = tool.reticule.depth
            depthStepper.isEnabled = tool.toolType == ToolType.tile
            
            widthTextField.integerValue = widthStepper.integerValue
            widthTextField.isEnabled = tool.toolType == ToolType.tile
            
            depthTextField.integerValue = depthStepper.integerValue
            depthTextField.isEnabled = tool.toolType == ToolType.tile
        }
    }
}

extension TerrainTerraformUtilitiesViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneView.GraticuleState?, to: SceneView.GraticuleState) {
        
        switch viewModel.state {
            
        case .terraform(let editor, let tool):
            
            switch to {
                
            case .tracking(let position, let closest, _, _):
                
                editor.meadow.scene.world.blueprint.clear()
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                
                var meshFaces: [MeshFace] = []
                
                switch tool.toolType {
                    
                case .corner:
                    
                    print("corner")
                    
                case .edge:
                    
                    print("edge")
                    
                case .tile:
                    
                    let minimumX = position.start.x
                    let maximumX = position.start.x + tool.reticule.width
                    let minimumZ = position.start.z
                    let maximumZ = position.start.z + tool.reticule.depth
                    
                    for x in minimumX..<maximumX {
                        
                        for z in minimumZ..<maximumZ {
                            
                            let coordinate = Coordinate(x: x, y: World.floor, z: z)
                            
                            if let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate) {
                            
                                let polytope = Polytope.translate(polytope: terrainNode.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                            
                                GridEdge.Edges.forEach { edge in
                                
                                    let corners = GridCorner.corners(edge: edge)
                                
                                    meshFaces.append(MeshFace.apex(corners: corners, polytope: polytope, color: colorPalette.secondary.vector))
                                }
                            }
                        }
                    }
                }
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                
            case .up(let position, let closest, let yOffset, _):
                
                switch tool.toolType {
                    
                case .corner:
                    
                    print("corner")
                    
                case .edge:
                    
                    print("edge")
                    
                case .tile:
                    
                    let minimumX = position.start.x
                    let maximumX = position.start.x + tool.reticule.width
                    let minimumZ = position.start.z
                    let maximumZ = position.start.z + tool.reticule.depth
                    
                    for x in minimumX..<maximumX {
                        
                        for z in minimumZ..<maximumZ {
                            
                            let coordinate = Coordinate(x: x, y: World.floor, z: z)
                            
                            GridEdge.Edges.forEach { edge in
                                
                                if let terrainLayer = editor.meadow.scene.world.terrain.find(edge: coordinate, edge: edge)?.topLayer {
                                    
                                    let corners = GridCorner.corners(edge: edge)
                                    
                                    let height = terrainLayer.peak
                                    
                                    terrainLayer.set(center: height)
                                    terrainLayer.set(corner: corners.c0, height: height)
                                    terrainLayer.set(corner: corners.c1, height: height)
                                }
                            }
                        }
                    }
                }
                
            default: break
            }
            
        default: break
        }
    }
}
