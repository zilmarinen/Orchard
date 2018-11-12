//
//  AreaBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class AreaBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var selectedExternalAreaTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedInternalAreaTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var selectedFloorColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var floorColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var selectedEdgeTypePopup: NSPopUpButton!
    @IBOutlet weak var selectedArchitectureTypePopup: NSPopUpButton!
    
    @IBOutlet weak var externalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var externalColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var internalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var internalColorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, var utility):
            
            switch sender {
                
            case selectedExternalAreaTypePopUp:
                
                guard let externalAreaType = AreaType(rawValue: sender.indexOfSelectedItem) else { break }
                
                utility.externalAreaType = externalAreaType
                
            case selectedInternalAreaTypePopUp:
                
                guard let internalAreaType = AreaType(rawValue: sender.indexOfSelectedItem) else { break }
                
                utility.internalAreaType = internalAreaType
                
            case selectedFloorColorPalettePopUp:
                
                guard let colorPalette = ColorPalettes.shared?.allColorPalettes[sender.indexOfSelectedItem] else { break }
                
                utility.floorColorPalette = colorPalette
                
            case selectedEdgeTypePopup:
                
                guard let selectedEdgeType = AreaNodeEdgeType(rawValue: sender.indexOfSelectedItem) else { break }
                
                utility.edgeType = selectedEdgeType
                
            case selectedArchitectureTypePopup:
                
                guard let selectedArchitectureType = AreaArchitectureType(rawValue: sender.indexOfSelectedItem) else { break }
                
                utility.architectureType = selectedArchitectureType
                
            case externalColorPalettePopup:
                
                guard let colorPalette = ColorPalettes.shared?.allColorPalettes[sender.indexOfSelectedItem] else { break }
                
                utility.externalColorPalette = colorPalette
                
            case internalColorPalettePopup:
                
                guard let colorPalette = ColorPalettes.shared?.allColorPalettes[sender.indexOfSelectedItem] else { break }
                
                utility.internalColorPalette = colorPalette
                
            default: break
            }
            
            viewModel.state = .build(editor: editor, utility: utility)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return AreaBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var cursorCallbackReference: SceneView.Cursor.CallbackReference?
    
    lazy var graticule = {
        
        return SceneView.TileGraticule()
    }()
    
    var tileGraticuleCallbackReference: SceneView.TileGraticule.CallbackReference?
}

extension AreaBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        tileGraticuleCallbackReference = graticule.subscribe(stateDidChange(from:to:))
    }
}

extension AreaBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let reference = cursorCallbackReference {
                
                editor.meadow.input.cursor.unsubscribe(reference)
            }
            
            graticule.state = .idle
            
        case .build(let editor, let utility):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))
            
            selectedExternalAreaTypePopUp.removeAllItems()
            selectedInternalAreaTypePopUp.removeAllItems()
            selectedFloorColorPalettePopUp.removeAllItems()
            selectedEdgeTypePopup.removeAllItems()
            selectedArchitectureTypePopup.removeAllItems()
            externalColorPalettePopup.removeAllItems()
            internalColorPalettePopup.removeAllItems()
            
            floorColorPaletteView.color = nil
            externalColorPaletteView.color = nil
            internalColorPaletteView.color = nil
            
            AreaType.allCases.forEach { areaType in
                
                selectedExternalAreaTypePopUp.addItem(withTitle: areaType.name)
                selectedInternalAreaTypePopUp.addItem(withTitle: areaType.name)
            }
            
            AreaNodeEdgeType.allCases.forEach { edgeType in
                
                selectedEdgeTypePopup.addItem(withTitle: edgeType.name)
            }
            
            AreaArchitectureType.allCases.forEach { architectureType in
                
                selectedArchitectureTypePopup.addItem(withTitle: architectureType.name)
            }
            
            ColorPalettes.shared?.allColorPalettes.forEach { colorPalette in
                
                selectedFloorColorPalettePopUp.addItem(withTitle: colorPalette.name)
                externalColorPalettePopup.addItem(withTitle: colorPalette.name)
                internalColorPalettePopup.addItem(withTitle: colorPalette.name)
            }
            
            if let index = AreaType.allCases.index(of: utility.externalAreaType) {
                
                selectedExternalAreaTypePopUp.selectItem(at: index)
            }
            
            if let index = AreaType.allCases.index(of: utility.internalAreaType) {
                
                selectedInternalAreaTypePopUp.selectItem(at: index)
            }
            
            if let index = ColorPalettes.shared?.allColorPalettes.index(of: utility.floorColorPalette) {
                
                selectedFloorColorPalettePopUp.selectItem(at: index)
                
                floorColorPaletteView.colorPalette = utility.floorColorPalette
            }
            
            if let index = AreaNodeEdgeType.allCases.index(of: utility.edgeType) {
                
                selectedEdgeTypePopup.selectItem(at: index)
            }
            
            if let index = AreaArchitectureType.allCases.index(of: utility.architectureType) {
                
                selectedArchitectureTypePopup.selectItem(at: index)
            }
            
            if let index = ColorPalettes.shared?.allColorPalettes.index(of: utility.externalColorPalette) {
                
                externalColorPalettePopup.selectItem(at: index)
                
                externalColorPaletteView.colorPalette = utility.externalColorPalette
            }
            
            if let index = ColorPalettes.shared?.allColorPalettes.index(of: utility.internalColorPalette) {
                
                internalColorPalettePopup.selectItem(at: index)
                
                internalColorPaletteView.colorPalette = utility.internalColorPalette
            }
        }
    }
}

extension AreaBuildUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .build(let editor, let utility):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: editor.meadow.scene.world,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue]
            
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
                
            case .up(_, let inputType, _):
                
                switch graticule.state {
                    
                case .tracking(let position, let startPosition, _):
                    
                    let minimumX = min(startPosition.x, position.x)
                    let maximumX = max(startPosition.x, position.x)
                    let minimumZ = min(startPosition.z, position.z)
                    let maximumZ = max(startPosition.z, position.z)
                    
                    let y = startPosition.y
                    
                    for x in minimumX...maximumX {
                        
                        for z in minimumZ...maximumZ {
                            
                            let coordinate = Coordinate(x: x, y: y, z: z)
                            
                            if inputType == .left {
                                
                                if let areaNode = editor.meadow.scene.world.areas.add(node: coordinate) {
                                
                                    areaNode.externalAreaType = utility.externalAreaType
                                    areaNode.internalAreaType = utility.internalAreaType
                                    areaNode.floorColorPalette = utility.floorColorPalette
                                    
                                    if x == minimumX {
                                        
                                        let edge = AreaNode.Edge(edge: .east, edgeType: utility.edgeType, architectureType: utility.architectureType, externalColorPalette: utility.externalColorPalette, internalColorPalette: utility.internalColorPalette)
                                        
                                        areaNode.set(edge: edge)
                                    }
                                    
                                    if x == maximumX {
                                        
                                        let edge = AreaNode.Edge(edge: .west, edgeType: utility.edgeType, architectureType: utility.architectureType, externalColorPalette: utility.externalColorPalette, internalColorPalette: utility.internalColorPalette)
                                        
                                        areaNode.set(edge: edge)
                                    }
                                    
                                    if z == maximumZ {
                                        
                                        let edge = AreaNode.Edge(edge: .north, edgeType: utility.edgeType, architectureType: utility.architectureType, externalColorPalette: utility.externalColorPalette, internalColorPalette: utility.internalColorPalette)
                                        
                                        areaNode.set(edge: edge)
                                    }
                                    
                                    if z == minimumZ {
                                        
                                        let edge = AreaNode.Edge(edge: .south, edgeType: utility.edgeType, architectureType: utility.architectureType, externalColorPalette: utility.externalColorPalette, internalColorPalette: utility.internalColorPalette)
                                        
                                        areaNode.set(edge: edge)
                                    }
                                }
                            }
                            else {
                                
                                if let areaNode = editor.meadow.scene.world.areas.find(node: coordinate) {
                                    
                                    let _ = editor.meadow.scene.world.areas.remove(node: areaNode)
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

extension AreaBuildUtilitiesViewController: TileGraticuleObserver {
    
    func stateDidChange(from: SceneView.TileGraticuleState?, to: SceneView.TileGraticuleState) {
        
        switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .build(let editor, _):
            
            editor.meadow.scene.world.blueprint.clear()
            
            switch graticule.state {
                
            case .tracking(let position, let startPosition, _):
                
                guard let colorPalette = ColorPalettes.shared?.palette(named: "Blueprint") else { break }
                
                var meshFaces: [MeshFace] = []
                
                let minimumX = min(startPosition.x, position.x)
                let maximumX = max(startPosition.x, position.x)
                let minimumZ = min(startPosition.z, position.z)
                let maximumZ = max(startPosition.z, position.z)
                
                let y = startPosition.y
                
                for x in minimumX...maximumX {
                    
                    for z in minimumZ...maximumZ {
                        
                        let coordinate = Coordinate(x: x, y: y, z: z)
                        
                        if let terrainLayer = editor.meadow.scene.world.terrain.find(node: coordinate)?.topLayer {
                            
                            let lowerY = Axis.Y(y: terrainLayer.polyhedron.upperPolytope.peak)
                            let upperY = lowerY + AreaNode.areaHeight
                            
                            let lowerPolytope = Polytope(x: MDWFloat(x), y0: lowerY, y1: lowerY, y2: lowerY, y3: lowerY, z: MDWFloat(z))
                            
                            let upperPolytope = Polytope(x: MDWFloat(x), y0: upperY, y1: upperY, y2: upperY, y3: upperY, z: MDWFloat(z))
                            
                            let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                            
                            var color = colorPalette.primary
                            
                            if editor.meadow.scene.world.areas.find(node: coordinate) != nil {
                                
                                color = colorPalette.tertiary
                            }
                            
                            GridEdge.Edges.forEach { edge in
                                
                                let corners = GridCorner.corners(edge: edge)
                                
                                let normal = GridEdge.normal(edge: edge)
                                
                                meshFaces.append(MeshProvider.surface(corners: corners, polytope: polyhedron.upperPolytope, color: color.vector))
                                
                                meshFaces.append(contentsOf: MeshProvider.edge(corners: corners, polyhedron: polyhedron, normal: normal, color: color.vector))
                            }
                        }
                    }
                }
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                
            default: break
            }
        }
    }
}
