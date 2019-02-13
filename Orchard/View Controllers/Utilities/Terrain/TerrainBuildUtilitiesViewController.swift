//
//  TerrainBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class TerrainBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, let tool):
            
            switch sender {
                
            case toolTypePopUp:
                
                guard let toolType = ToolType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .build(editor: editor, tool: (toolType: toolType, terrainType: tool.terrainType))
                
            case terrainTypePopUp:
                
                guard let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .build(editor: editor, tool: (toolType: tool.toolType, terrainType: terrainType))
                
            default: break
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainBuildUtilitiesViewModel(initialState: .empty(editor: nil))
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

extension TerrainBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        edgeGraticuleCallbackReference = edgeGraticule.subscribe(stateDidChange(from:to:))
        
        tileGraticuleCallbackReference = tileGraticule.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let reference = cursorCallbackReference {
                
                editor.meadow.input.cursor.unsubscribe(reference)
            }
            
        case .build(let editor, let tool):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))
            
            terrainTypePopUp.removeAllItems()
            toolTypePopUp.removeAllItems()
            
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

extension TerrainBuildUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .build(let editor, let tool):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: editor.meadow.scene.world,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue | SceneGraphNodeType.floor.rawValue]
         
            switch to {
                
            case .idle(let position):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate)
                
                let polytope = (terrainNode?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                
                switch tool.toolType {
                    
                case .edge:
                    
                    let closestEdge = polytope.closest(edge: hit.worldCoordinates)
                    
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
                        
                    case .tracking(let position, _, let yOffset):
                        
                        if position != coordinate {
                            
                            tileGraticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: yOffset)
                        }
                    }
                }
                
            case .down(let position, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate)
                
                let polytope = (terrainNode?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                
                switch tool.toolType {
                    
                case .edge:
                    
                    let closestEdge = polytope.closest(edge: hit.worldCoordinates)
                    
                    edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: 0)
                    
                case .tile:
                    
                    tileGraticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                }
                
            case .tracking(let position, _, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate)
                
                let polytope = (terrainNode?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                
                switch tool.toolType {
                    
                case .edge:
                    
                    let closestEdge = polytope.closest(edge: hit.worldCoordinates)
                    
                    switch edgeGraticule.state {
                        
                    case .tracking(let position, let edge, let yOffset):
                        
                        if position != coordinate {
                        
                            edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: yOffset)
                        }
                        
                    default: break
                    }
                    
                case .tile:
                    
                    switch tileGraticule.state {
                        
                    case .tracking(let position, let startPosition, let yOffset):
                        
                        if position != coordinate {
                        
                            tileGraticule.state = .tracking(position: coordinate, startPosition: startPosition, yOffset: yOffset)
                        }
                        
                    default: break
                    }
                }
                
            case .up(let position, let inputType, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch tool.toolType {
                    
                case .edge:
                    
                    let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate)
                    
                    let polytope = (terrainNode?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                    
                    let closestEdge = polytope.closest(edge: hit.worldCoordinates)
                    
                    if inputType == .left {
                        
                        let _ = editor.meadow.scene.world.terrain.add(layer: coordinate, edge: closestEdge, terrainType: tool.terrainType)
                    }
                    else {
                        
                        if let nodeEdge = terrainNode?.find(edge: closestEdge), let layer = nodeEdge.topLayer {
                            
                            editor.meadow.scene.world.terrain.remove(layer: layer)
                        }
                    }
                    
                    edgeGraticule.state = .idle
                    
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
                                
                                GridEdge.Edges.forEach { edge in
                                    
                                    if inputType == .left {
                                    
                                        let _ = editor.meadow.scene.world.terrain.add(layer: coordinate, edge: edge, terrainType: tool.terrainType)
                                    }
                                    else {
                                    
                                        if let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate) {
                                        
                                            if let nodeEdge = terrainNode.find(edge: edge), let layer = nodeEdge.topLayer {
                                                
                                                editor.meadow.scene.world.terrain.remove(layer: layer)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    default: break
                    }
                    
                    tileGraticule.state = .idle
                }
            }
            
        default: break
        }
    }
}

extension TerrainBuildUtilitiesViewController: EdgeGraticuleObserver {
    
    func stateDidChange(from: SceneView.EdgeGraticuleState?, to: SceneView.EdgeGraticuleState) {
        
        switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .build(let editor, _):
            
            editor.meadow.scene.world.blueprint.clear()
            
            guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
            
            var meshFaces: [MeshFace] = []
            
            switch edgeGraticule.state {
                
            case .tracking(let position, let edge, _):
                
                let terrainNode = editor.meadow.scene.world.terrain.find(node: position)
                
                let nodeEdge = terrainNode?.find(edge: edge)
                
                let lowerPolytope = (nodeEdge?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(position.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(position.z)))
                
                let upperPolytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY, z: 0.0))
                
                let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                
                var color = colorPalette.primary
                
                switch editor.meadow.input.cursor.state {
                    
                case .down(_, let inputType),
                     .tracking(_, let inputType, _),
                     .up(_, let inputType, _):
                    
                    if inputType == .left {
                        
                        color = colorPalette.secondary
                    }
                    else {
                        
                        color = colorPalette.tertiary
                    }
                    
                default: break
                }
                
                let (c0, c1) = GridCorner.corners(edge: edge)
                
                let edgeNormal = GridEdge.normal(edge: edge)
                let inverseNormal = SCNVector3.negate(vector: edgeNormal)
                
                meshFaces.append(MeshFace.apex(corners: (c0: c0, c1: c1), polytope: polyhedron.upperPolytope, color: color.vector))
                
                meshFaces.append(contentsOf: MeshFace.edge(corners: (c0: c0, c1: c1), polyhedron: polyhedron, normal: edgeNormal, color: color.vector))
                
                let (e0, e1) = GridEdge.edges(edge: edge)
                
                [e0, e1].forEach { connectedEdge in
                    
                    let diagonalNormal = inverseNormal + GridEdge.normal(edge: connectedEdge)
                    
                    let (c2, c3) = GridCorner.corners(edge: connectedEdge)
                    
                    let corner = (c2 == c0 ? c2 : (c2 == c1 ? c2 : c3))
                    
                    let cornerUpper = polyhedron.upperPolytope.vertices[corner.rawValue]
                    let centreUpper = polyhedron.upperPolytope.center
                    
                    let cornerLower = polyhedron.lowerPolytope.vertices[corner.rawValue]
                    let centerLower = polyhedron.lowerPolytope.center
                    
                    let polytope = Polytope(v0: cornerUpper, v1: centreUpper, v2: centerLower, v3: cornerLower)
                    
                    meshFaces.append(contentsOf: MeshFace.diagonal(polytope: polytope, normal: diagonalNormal, color: colorPalette.secondary.vector))
                }
                
            default: break
            }
            
            editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
        }
    }
}

extension TerrainBuildUtilitiesViewController: TileGraticuleObserver {
    
    func stateDidChange(from: SceneView.TileGraticuleState?, to: SceneView.TileGraticuleState) {
        
        switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .build(let editor, _):
            
            editor.meadow.scene.world.blueprint.clear()
            
            guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
            
            var meshFaces: [MeshFace] = []
            
            switch tileGraticule.state {
                
            case .tracking(let position, let startPosition, _):
                
                let minimumX = min(startPosition.x, position.x)
                let maximumX = max(startPosition.x, position.x)
                let minimumZ = min(startPosition.z, position.z)
                let maximumZ = max(startPosition.z, position.z)
                
                for x in minimumX...maximumX {
                    
                    for z in minimumZ...maximumZ {
                        
                        let coordinate = Coordinate(x: x, y: World.floor, z: z)
                        
                        let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate)
                        
                        let lowerPolytope = (terrainNode?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                        
                        let upperPolytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY, z: 0.0))
                        
                        let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                        
                        var color = colorPalette.primary
                        
                        switch editor.meadow.input.cursor.state {
                            
                        case .down(_, let inputType),
                             .tracking(_, let inputType, _),
                             .up(_, let inputType, _):
                            
                            if inputType == .left {
                                
                                color = colorPalette.secondary
                            }
                            else {
                                
                                color = colorPalette.tertiary
                            }
                            
                        default: break
                        }
                        
                        GridEdge.Edges.forEach { edge in
                            
                            let corners = GridCorner.corners(edge: edge)
                            
                            let normal = GridEdge.normal(edge: edge)
                            
                            meshFaces.append(MeshFace.apex(corners: corners, polytope: polyhedron.upperPolytope, color: color.vector))
                            
                            meshFaces.append(contentsOf: MeshFace.edge(corners: corners, polyhedron: polyhedron, normal: normal, color: color.vector))
                        }
                    }
                }
                
            default: break
            }
            
            editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
        }
    }
}
