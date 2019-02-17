//
//  WaterBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 18/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class WaterBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var waterTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, _):
            
            guard let waterType = WaterType(rawValue: sender.indexOfSelectedItem) else { break }
            
            viewModel.state = .build(editor: editor, waterType: waterType)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return WaterBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var cursorCallbackReference: SceneView.Cursor.CallbackReference?
    
    lazy var edgeGraticule = {
        
        return SceneView.EdgeGraticule()
    }()
    
    var edgeGraticuleCallbackReference: SceneView.EdgeGraticule.CallbackReference?
}

extension WaterBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        edgeGraticuleCallbackReference = edgeGraticule.subscribe(stateDidChange(from:to:))
    }
}

extension WaterBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let reference = cursorCallbackReference {
                
                editor.meadow.input.cursor.unsubscribe(reference)
            }
            
        case .build(let editor, let waterType):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))
            
            waterTypePopUp.removeAllItems()
            
            colorPaletteView.color = nil
            
            WaterType.allCases.forEach { waterType in
                
                waterTypePopUp.addItem(withTitle: waterType.name)
            }
            
            if let index = WaterType.allCases.index(of: waterType), let colorPalette = waterType.colorPalette {
                
                waterTypePopUp.selectItem(at: index)
                
                colorPaletteView.colorPalette = colorPalette
            }
        }
    }
}

extension WaterBuildUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .build(let editor, let waterType):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: editor.meadow.scene.world,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue]
            
            switch to {
                
            case .idle(let position):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate)
                
                let polytope = (terrainNode?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                
                let closestEdge = polytope.closest(edge: hit.worldCoordinates)
                
                switch edgeGraticule.state {
                    
                case .idle:
                    
                    edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: 0)
                    
                case .tracking(let position, let edge, let yOffset):
                    
                    if position != coordinate && edge != closestEdge {
                        
                        edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: yOffset)
                    }
                }
                
            case .down(let position, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate)
                
                let polytope = (terrainNode?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                
                let closestEdge = polytope.closest(edge: hit.worldCoordinates)
                
                edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: 0)
                
            case .tracking(let position, _, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate)
                
                let polytope = (terrainNode?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                
                let closestEdge = polytope.closest(edge: hit.worldCoordinates)
                
                switch edgeGraticule.state {
                    
                case .tracking(let position, let edge, let yOffset):
                    
                    if position != coordinate && edge != closestEdge {
                        
                        edgeGraticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: yOffset)
                    }
                    
                default: break
                }
                
            case .up(let position, let inputType, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                if let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate) {
                
                    let closestEdge = terrainNode.polyhedron.upperPolytope.closest(edge: hit.worldCoordinates)
                    
                    if let terrainNodeEdge = terrainNode.find(edge: closestEdge) {
                    
                        if inputType == .left, let terrainEdgeLayer = terrainNodeEdge.topLayer {
                    
                            let waterNodeEdge = editor.meadow.scene.world.water.add(edge: coordinate, edge: closestEdge, waterType: waterType)
                    
                            waterNodeEdge?.waterType = waterType
                            waterNodeEdge?.waterLevel = terrainEdgeLayer.peak + 1
                        }
                        else {
                            
                            let waterNode = editor.meadow.scene.world.water.find(node: coordinate)
                    
                            if let nodeEdge = waterNode?.find(edge: closestEdge) {
                        
                                let _ = editor.meadow.scene.world.water.remove(edge: nodeEdge)
                            }
                        }
                    }
                }
                
                edgeGraticule.state = .idle
            }
            
        default: break
        }
    }
}

extension WaterBuildUtilitiesViewController: EdgeGraticuleObserver {
    
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
                
                guard let terrainNode = editor.meadow.scene.world.terrain.find(node: position), let nodeEdge = terrainNode.find(edge: edge) else { break }
                
                let upperPolytope = Polytope.translate(polytope: nodeEdge.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY, z: 0.0))
                
                let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: nodeEdge.polyhedron.upperPolytope)
                
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
                    
                    meshFaces.append(contentsOf: MeshFace.diagonal(polytope: polytope, normal: diagonalNormal, color: color.vector))
                }
                
            default: break
            }
            
            editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
        }
    }
}
