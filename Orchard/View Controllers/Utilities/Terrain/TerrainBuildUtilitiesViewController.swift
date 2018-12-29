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
    
    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, _):
            
            guard let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
            
            viewModel.state = .build(editor: editor, terrainType: terrainType)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var cursorCallbackReference: SceneView.Cursor.CallbackReference?
    
    lazy var graticule = {
       
        return SceneView.TileGraticule()
    }()
    
    var tileGraticuleCallbackReference: SceneView.TileGraticule.CallbackReference?
}

extension TerrainBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        tileGraticuleCallbackReference = graticule.subscribe(stateDidChange(from:to:))
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
            
            graticule.state = .idle
            
        case .build(let editor, let terrainType):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))
            
            terrainTypePopUp.removeAllItems()
            
            colorPaletteView.color = nil
            
            TerrainType.allCases.forEach { terrainType in
                
                terrainTypePopUp.addItem(withTitle: terrainType.name)
            }
            
            if let index = TerrainType.allCases.index(of: terrainType), let colorPalette = terrainType.colorPalette {
                
                terrainTypePopUp.selectItem(at: index)
                
                colorPaletteView.colorPalette = colorPalette
            }
        }
    }
}

extension TerrainBuildUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .build(let editor, let terrainType):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: editor.meadow.scene.world,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue | SceneGraphNodeType.floor.rawValue]
         
            switch to {
                
            case .idle(let position):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch graticule.state {
                
                case .idle:
                    
                    graticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                    
                case .tracking(let position, _, _):
                    
                    if position != coordinate {
                        
                        graticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                    }
                }
                
            case .down(let position, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                graticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                
            case .tracking(let position, _, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch graticule.state {
                    
                case .tracking(let position, let startPosition, _):
                    
                    if position != coordinate {
                    
                        graticule.state = .tracking(position: coordinate, startPosition: startPosition, yOffset: 0)
                    }
                    
                default: break
                }
                
            case .up(let position, let inputType, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch graticule.state {
                    
                case .tracking(_, let startPosition, _):
                    
                    let minimumX = min(startPosition.x, coordinate.x)
                    let maximumX = max(startPosition.x, coordinate.x)
                    let minimumZ = min(startPosition.z, coordinate.z)
                    let maximumZ = max(startPosition.z, coordinate.z)
                    
                    for x in minimumX...maximumX {
                        
                        for z in minimumZ...maximumZ {
                            
                            let coordinate = Coordinate(x: x, y: World.floor, z: z)
                            
                            if inputType == .left {
                                
                                let _ = editor.meadow.scene.world.terrain.add(layer: coordinate, terrainType: terrainType)
                            }
                            else {
                                
                                if let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer {
                                    
                                    let _ = editor.meadow.scene.world.terrain.remove(layer: terrainLayer)
                                }
                            }
                        }
                    }
                    
                default: break
                }
                
                graticule.state = .idle
            }
            
        default: break
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
            
            switch graticule.state {
                
            case .tracking(let position, let startPosition, _):
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                
                var meshFaces: [MeshFace] = []
                
                let minimumX = min(startPosition.x, position.x)
                let maximumX = max(startPosition.x, position.x)
                let minimumZ = min(startPosition.z, position.z)
                let maximumZ = max(startPosition.z, position.z)
                
                for x in minimumX...maximumX {
                
                    for z in minimumZ...maximumZ {
                        
                        let coordinate = Coordinate(x: x, y: World.floor, z: z)
                        
                        var lowerPolytope: Polytope!
                        
                        if let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer {
                            
                            lowerPolytope = terrainLayer.polyhedron.upperPolytope
                        }
                        else {
                         
                            lowerPolytope = Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z))
                        }
                        
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
                            
                            meshFaces.append(MeshProvider.surface(corners: corners, polytope: polyhedron.upperPolytope, color: color.vector))
                            
                            meshFaces.append(contentsOf: TerrainMeshProvider.terrainLayer(crown: corners, acuteCorner: nil, polyhedron: polyhedron, normal: normal, color: color.vector))
                            meshFaces.append(contentsOf: TerrainMeshProvider.terrainLayer(throne: corners, acuteCorner: nil, polyhedron: polyhedron, normal: normal, color: color.vector))
                        }
                    }
                }
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                
            default: break
            }
        }
    }
}
