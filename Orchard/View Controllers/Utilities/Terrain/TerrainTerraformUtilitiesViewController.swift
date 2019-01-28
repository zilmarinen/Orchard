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
    
    var cursorCallbackReference: SceneView.Cursor.CallbackReference?
    
    lazy var cornerGraticule = {
    
        return SceneView.CornerGraticule()
    }()
    
    var cornerGraticuleCallbackReference: SceneView.CornerGraticule.CallbackReference?
    
    lazy var edgeGraticule = {
       
        return SceneView.EdgeGraticule()
    }()
    
    var edgeGraticuleCallbackReference: SceneView.EdgeGraticule.CallbackReference?
    
    lazy var tileGraticule = {
       
        return SceneView.TileGraticule()
    }()
    
    var tileGraticuleCallbackReference: SceneView.TileGraticule.CallbackReference?
}

extension TerrainTerraformUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        cornerGraticuleCallbackReference = cornerGraticule.subscribe(stateDidChange(from:to:))
        
        edgeGraticuleCallbackReference = edgeGraticule.subscribe(stateDidChange(from:to:))
        
        tileGraticuleCallbackReference = tileGraticule.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainTerraformUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let reference = cursorCallbackReference {
                
                editor.meadow.input.cursor.unsubscribe(reference)
            }
            
        case .terraform(let editor, let tool):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))
            
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

extension TerrainTerraformUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        /*switch viewModel.state {
            
        case .terraform(let editor, let toolType, let reticule):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: editor.meadow.scene.world.terrain,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue]
            
            switch to {
                
            case .idle(let position):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                guard let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer else { break }
                
                switch toolType {
                    
                case .corner:
                    
                    let closestCorner = terrainLayer.polyhedron.upperPolytope.closest(corner: hit.worldCoordinates)
                    
                    switch cornerGraticule.state {
                        
                    case .idle:
                        
                        cornerGraticule.state = .tracking(position: coordinate, corner: closestCorner, yOffset: 0)
                        
                    case .tracking(let position, let corner, let yOffset):
                        
                        if position != coordinate && corner != closestCorner {
                            
                            cornerGraticule.state = .tracking(position: coordinate, corner: closestCorner, yOffset: yOffset)
                        }
                    }
                    
                case .edge:
                    
                    let closestEdge = terrainLayer.polyhedron.upperPolytope.closest(edge: hit.worldCoordinates)
                    
                    switch edgeGraticule.state {
                        
                    case .idle:
                        
                        edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: 0)
                    
                    case .tracking(let position, let edge, let yOffset):
                        
                        if position != coordinate && edge != closestEdge {
                            
                            edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: yOffset)
                        }
                    }
                    
                case .tile:
                    
                    switch tileGraticule.state {
                        
                    case .idle:
                        
                        tileGraticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                        
                    case .tracking(let position, let startPosition, let yOffset):
                        
                        if position != coordinate {
                            
                            tileGraticule.state = .tracking(position: coordinate, startPosition: startPosition, yOffset: yOffset)
                        }
                    }
                }
                
            case .down(let position, let inputType):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                guard let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer else { break }
                
                if inputType == .right {
                    
                    editor.delegate.sceneGraph(didSelectChild: terrainLayer, atIndex: 0)
                }
                
                switch toolType {
                    
                case .corner:
                    
                    let closestCorner = terrainLayer.polyhedron.upperPolytope.closest(corner: hit.worldCoordinates)
                    
                    cornerGraticule.state = .tracking(position: coordinate, corner: closestCorner, yOffset: 0)
                    
                case .edge:
                    
                    let closestEdge = terrainLayer.polyhedron.upperPolytope.closest(edge: hit.worldCoordinates)
                    
                    edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: 0)
                    
                case .tile:
                    
                    tileGraticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                }
                
            case .tracking(let position, _, let startPosition):
                
                let offset = Int(round((position.y - startPosition.y) / 25))
                
                switch toolType {
                    
                case .corner:
                    
                    switch cornerGraticule.state {
                        
                    case .tracking(let position, let corner, let yOffset):
                        
                        if yOffset != offset {
                            
                            guard let terrainLayer = editor.meadow.scene.world.terrain.find(node: position)?.topLayer else { break }
                            
                            let height = (position.y + offset)
                            
                            terrainLayer.set(height: height, corner: corner)
                        
                            cornerGraticule.state = .tracking(position: position, corner: corner, yOffset: offset)
                        }
                        
                    default: break
                    }
                    
                case .edge:
                    
                    switch edgeGraticule.state {
                        
                    case .tracking(let position, let edge, let yOffset):
                        
                        if yOffset != offset {
                            
                            guard let terrainLayer = editor.meadow.scene.world.terrain.find(node: position)?.topLayer else { break }
                            
                            let (c0, c1) = GridCorner.corners(edge: edge)
                            
                            let height = (position.y + offset)
                            
                            terrainLayer.set(height: height, corner: c0)
                            terrainLayer.set(height: height, corner: c1)
                            
                            edgeGraticule.state = .tracking(position: position, edge: edge, yOffset: offset)
                        }
                        
                    default: break
                    }
                    
                case .tile:
                    
                    switch tileGraticule.state {
                        
                    case .tracking(let position, let startPosition, let yOffset):
                        
                        if yOffset != offset {
                            
                            let height = (position.y + offset)
                            
                            let minimumX = position.x
                            let maximumX = position.x + (reticule.width - 1)
                            let minimumZ = position.z
                            let maximumZ = position.z + (reticule.depth - 1)
                            
                            for x in minimumX...maximumX {
                                
                                for z in minimumZ...maximumZ {
                                    
                                    let coordinate = Coordinate(x: x, y: World.floor, z: z)
                                    
                                    if let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer {
                            
                                        terrainLayer.set(height: height)
                                    }
                                }
                            }
                            
                            tileGraticule.state = .tracking(position: position, startPosition: startPosition, yOffset: offset)
                        }
                        
                    default: break
                    }
                }
                
            case .up:
                
                switch toolType {
                    
                case .corner:
                    
                    cornerGraticule.state = .idle
                    
                case .edge:
                    
                    edgeGraticule.state = .idle
                    
                case .tile:
                    
                    tileGraticule.state = .idle
                }
            }
            
        default: break
        }*/
    }
}

extension TerrainTerraformUtilitiesViewController: CornerGraticuleObserver {
    
    func stateDidChange(from: SceneView.CornerGraticuleState?, to: SceneView.CornerGraticuleState) {
        
        /*switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .terraform(let editor, _, _):
            
            editor.meadow.scene.world.blueprint.clear()
            
            switch cornerGraticule.state {
                
            case .tracking(let position, let corner, _):
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint"), let terrainLayer = editor.meadow.scene.world.terrain.find(node: position)?.topLayer else { break }
                
                var meshFaces: [MeshFace] = []
                
                let polytope = Polytope.translate(polytope: terrainLayer.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                    
                let (e0, e1) = GridEdge.edges(corner: corner)
                
                [e0, e1].forEach { edge in
                    
                    let corners = GridCorner.corners(edge: edge)
                    
                    meshFaces.append(MeshProvider.surface(corners: corners, polytope: polytope, color: colorPalette.primary.vector))
                }
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                
            default: break
            }
        }*/
    }
}

extension TerrainTerraformUtilitiesViewController: EdgeGraticuleObserver {
    
    func stateDidChange(from: SceneView.EdgeGraticuleState?, to: SceneView.EdgeGraticuleState) {
        
        /*switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .terraform(let editor, _, _):
            
            editor.meadow.scene.world.blueprint.clear()
            
            switch edgeGraticule.state {
                
            case .tracking(let position, let edge, _):
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint"), let terrainLayer = editor.meadow.scene.world.terrain.find(node: position)?.topLayer else { break }
                
                let corners = GridCorner.corners(edge: edge)
                
                let polytope = Polytope.translate(polytope: terrainLayer.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                
                let meshFace = MeshProvider.surface(corners: corners, polytope: polytope, color: colorPalette.primary.vector)
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: [meshFace]))
                
            default: break
            }
        }*/
    }
}

extension TerrainTerraformUtilitiesViewController: TileGraticuleObserver {
    
    func stateDidChange(from: SceneView.TileGraticuleState?, to: SceneView.TileGraticuleState) {
        
        /*switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .terraform(let editor, _, let reticule):
            
            editor.meadow.scene.world.blueprint.clear()
            
            switch tileGraticule.state {
                
            case .tracking(let position, _, _):
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                
                var meshFaces: [MeshFace] = []
                
                let minimumX = position.x
                let maximumX = position.x + (reticule.width - 1)
                let minimumZ = position.z
                let maximumZ = position.z + (reticule.depth - 1)
                
                for x in minimumX...maximumX {
                    
                    for z in minimumZ...maximumZ {
                        
                        let coordinate = Coordinate(x: x, y: World.floor, z: z)
                        
                        if let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer {
                            
                            let polytope = Polytope.translate(polytope: terrainLayer.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                            
                            GridEdge.Edges.forEach { edge in
                                
                                let corners = GridCorner.corners(edge: edge)
                                
                                meshFaces.append(MeshProvider.surface(corners: corners, polytope: polytope, color: colorPalette.primary.vector))
                            }
                        }
                    }
                }
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                
            default: break
            }
        }*/
    }
}
