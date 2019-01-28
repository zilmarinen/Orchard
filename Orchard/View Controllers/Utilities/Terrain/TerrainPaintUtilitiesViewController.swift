//
//  TerrainPaintUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class TerrainPaintUtilitiesViewController: NSViewController {

    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
     
        switch viewModel.state {
            
        case .paint(let editor, let tool):
            
            switch sender {
                
            case toolTypePopUp:
                
                guard let toolType = ToolType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .paint(editor: editor, tool: (toolType: toolType, terrainType: tool.terrainType))
                
            case terrainTypePopUp:
                
                guard let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .paint(editor: editor, tool: (toolType: tool.toolType, terrainType: terrainType))
                
            default: break
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainPaintUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var cursorCallbackReference: SceneView.Cursor.CallbackReference?
    
    lazy var edgeGraticule = {
        
        return SceneView.EdgeGraticule()
    }()
    
    var edgeGraticuleCallbackReference: SceneView.EdgeGraticule.CallbackReference?
    
    lazy var tileGraticule = {
    
        return SceneView.TileGraticule()
    }()
    
    var tileGraticuleCallbackReference: SceneView.TileGraticule.CallbackReference?
}

extension TerrainPaintUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        tileGraticuleCallbackReference = tileGraticule.subscribe(stateDidChange(from:to:))
        
        edgeGraticuleCallbackReference = edgeGraticule.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainPaintUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let reference = cursorCallbackReference {
            
                editor.meadow.input.cursor.unsubscribe(reference)
            }
            
        case .paint(let editor, let tool):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))
            
            terrainTypePopUp.removeAllItems()
            toolTypePopUp.removeAllItems()
            
            toolTypePopUp.addItem(withTitle: "Corner")
            toolTypePopUp.addItem(withTitle: "Edge")
            toolTypePopUp.addItem(withTitle: "Tile")
            
            toolTypePopUp.selectItem(at: tool.toolType.rawValue)
            
            colorPaletteView.color = nil
            
            TerrainType.allCases.forEach { terrainType in
                
                terrainTypePopUp.addItem(withTitle: terrainType.name)
            }
            
            if let index = TerrainType.allCases.index(of: tool.terrainType), let colorPalette = tool.terrainType.colorPalette {
                
                terrainTypePopUp.selectItem(at: index)
                
                colorPaletteView.colorPalette = colorPalette
            }
        }
    }
}

extension TerrainPaintUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        /*switch viewModel.state {
            
        case .paint(let editor, let terrainType, let toolType):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: editor.meadow.scene.world.terrain,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue]
            
            switch to {
                
            case .idle(let position):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch toolType {
                    
                case .edge:
                    
                    guard let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer else { break }
                    
                    let closestEdge = terrainLayer.polyhedron.upperPolytope.closest(edge: hit.worldCoordinates)
                    
                    switch edgeGraticule.state {
                        
                    case .idle:
                        
                        edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: 0)
                        
                    case .tracking(let position, let edge, _):
                        
                        if position != coordinate && edge != closestEdge {
                            
                            edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: 0)
                        }
                    }
                    
                case .tile:
                    
                    switch tileGraticule.state {
                        
                    case .idle:
                        
                        tileGraticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                        
                    case .tracking(let position, _, _):
                        
                        if position != coordinate {
                            
                            tileGraticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                        }
                    }
                }
                
            case .down(let position, let inputType):
                
                if inputType == .right {
                    
                    guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                    let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                    guard let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer else { break }
                    
                    editor.delegate.sceneGraph(didSelectChild: terrainLayer, atIndex: 0)
                }
                
            case .tracking(let position, _, _):
                
                switch toolType {
                    
                case .tile:
                    
                    guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                    
                    let coordinate = Coordinate(vector: hit.worldCoordinates)
                    
                    switch tileGraticule.state {
                        
                    case .tracking(let position, let startPosition, _):
                        
                        if position != coordinate {
                            
                            tileGraticule.state = .tracking(position: coordinate, startPosition: startPosition, yOffset: 0)
                        }
                        
                    default: break
                    }
                    
                default: break
                }
                
            case .up(let position, _, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch toolType {
                    
                case .edge:
                    
                    switch edgeGraticule.state {
                        
                    case .tracking(let position, let edge, _):
                        
                        guard let terrainLayer = editor.meadow.scene.world.terrain.find(node: position)?.topLayer else { break }
                        
                        guard terrainLayer.get(terrainType: edge) != terrainType else { break }
                        
                        terrainLayer.set(terrainType: terrainType, edge: edge)
                        
                    default: break
                    }
                    
                case .tile:
                    
                    switch tileGraticule.state {
                        
                    case .tracking(_, let startPosition, _):
                        
                        let minimumX = min(startPosition.x, coordinate.x)
                        let maximumX = max(startPosition.x, coordinate.x)
                        let minimumZ = min(startPosition.z, coordinate.z)
                        let maximumZ = max(startPosition.z, coordinate.z)

                        for x in minimumX...maximumX {

                            for z in minimumZ...maximumZ {

                                let coordinate = Coordinate(x: x, y: World.floor, z: z)

                                if let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer {

                                    terrainLayer.set(terrainType: terrainType)
                                }
                            }
                        }
                        
                    default: break
                    }
                }
            }
            
        default: break
        }*/
    }
}

extension TerrainPaintUtilitiesViewController: TileGraticuleObserver {
    
    func stateDidChange(from: SceneView.TileGraticuleState?, to: SceneView.TileGraticuleState) {
    
        /*switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .paint(let editor, let terrainType, _):
            
            editor.meadow.scene.world.blueprint.clear()
            
            switch tileGraticule.state {
                
            case .tracking(let position, let startPosition, _):
                
                guard let colorPalette = terrainType.colorPalette else { break }
                
                var meshFaces: [MeshFace] = []
                
                let minimumX = min(startPosition.x, position.x)
                let maximumX = max(startPosition.x, position.x)
                let minimumZ = min(startPosition.z, position.z)
                let maximumZ = max(startPosition.z, position.z)
                
                for x in minimumX...maximumX {
                    
                    for z in minimumZ...maximumZ {
                        
                        let coordinate = Coordinate(x: x, y: World.floor, z: z)
                        
                        if let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer {
                            
                            let polytope = Polytope.translate(polytope: terrainLayer.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                            
                            GridEdge.Edges.forEach { edge in
                                
                                if terrainLayer.get(terrainType: edge) != terrainType {
                                 
                                    let corners = GridCorner.corners(edge: edge)
                                    
                                    meshFaces.append(MeshProvider.surface(corners: corners, polytope: polytope, color: colorPalette.primary.vector))
                                }
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

extension TerrainPaintUtilitiesViewController: EdgeGraticuleObserver {
    
    func stateDidChange(from: SceneView.EdgeGraticuleState?, to: SceneView.EdgeGraticuleState) {
        
        /*switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .paint(let editor, let terrainType, _):
            
            editor.meadow.scene.world.blueprint.clear()
            
            switch edgeGraticule.state {
                
            case .tracking(let position, let edge, _):
                
                guard let colorPalette = terrainType.colorPalette, let terrainLayer = editor.meadow.scene.world.terrain.find(node: position)?.topLayer else { break }
                
                guard terrainLayer.get(terrainType: edge) != terrainType else { break }
                    
                let corners = GridCorner.corners(edge: edge)
                
                let polytope = Polytope.translate(polytope: terrainLayer.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                
                let meshFace = MeshProvider.surface(corners: corners, polytope: polytope, color: colorPalette.primary.vector)
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: [meshFace]))
                
            default: break
            }
        }*/
    }
}
