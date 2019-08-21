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
    
    @IBOutlet weak var fixtureBox: NSBox!
    
    @IBOutlet weak var externalEdgesButton: NSButton!
    
    @IBOutlet weak var edgeTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var floorTypePopUp: NSPopUpButton!
    @IBOutlet weak var floorColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var floorColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var internalMaterialPopUp: NSPopUpButton!
    @IBOutlet weak var internalColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var internalColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var externalMaterialPopUp: NSPopUpButton!
    @IBOutlet weak var externalColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var externalColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var fixtureTypePopUp: NSPopUpButton!
    @IBOutlet weak var fixtureColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var fixtureColorPaletteView: ColorPaletteView!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .build(let editor, var tool):
            
            switch sender {
                
            case externalEdgesButton:
                
                tool.externalEdges = sender.state == .on
                
            default: break
            }
            
            viewModel.state = .build(editor: editor, tool: tool)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, var tool):
            
            switch sender {
                
            case edgeTypePopUp:
                
                guard let edgeType = AreaNodeEdgeType.CodingKeys(rawValue: sender.indexOfSelectedItem) else { break }
                
                switch edgeType {
                    
                case .door:
                    
                    guard let doorType = AreaNodeEdgeDoorType(rawValue: fixtureTypePopUp.indexOfSelectedItem), let colorPalette = ArtDirector.shared?.palettes.children[fixtureColorPalettePopUp.indexOfSelectedItem] else { break }
                    
                    let door = AreaNodeEdgeDoor(colorPalette: colorPalette, doorType: doorType)
                    
                    tool.edgeType = AreaNodeEdgeType.door(door)
                    
                case .wall:
                    
                    tool.edgeType = AreaNodeEdgeType.wall
                    
                case .window:
                    
                    guard let windowType = AreaNodeEdgeWindowType(rawValue: fixtureTypePopUp.indexOfSelectedItem), let colorPalette = ArtDirector.shared?.palettes.children[fixtureColorPalettePopUp.indexOfSelectedItem] else { break }
                    
                    let window = AreaNodeEdgeWindow(colorPalette: colorPalette, windowType: windowType)
                    
                    tool.edgeType = AreaNodeEdgeType.window(window)
                }
                
            case floorColorPalettePopUp,
                 floorTypePopUp:
                
                guard let floorType = AreaNodeFloorType(rawValue: floorTypePopUp.indexOfSelectedItem), let colorPalette = ArtDirector.shared?.palettes.children[floorColorPalettePopUp.indexOfSelectedItem] else { break }
                
                tool.floor = AreaNodeFloor(colorPalette: colorPalette, floorType: floorType)
                
            case internalMaterialPopUp,
                 internalColorPalettePopUp:
                
                guard let material = AreaNodeEdgeMaterial(rawValue: internalMaterialPopUp.indexOfSelectedItem), let colorPalette = ArtDirector.shared?.palettes.children[internalColorPalettePopUp.indexOfSelectedItem] else { break }
                
                tool.internalEdgeFace = AreaNodeEdgeFace(colorPalette: colorPalette, material: material)
                
            case externalMaterialPopUp,
                 externalColorPalettePopUp:
                
                guard let material = AreaNodeEdgeMaterial(rawValue: externalMaterialPopUp.indexOfSelectedItem), let colorPalette = ArtDirector.shared?.palettes.children[externalColorPalettePopUp.indexOfSelectedItem] else { break }
                
                tool.externalEdgeFace = AreaNodeEdgeFace(colorPalette: colorPalette, material: material)
                
            default: break
            }
            
            viewModel.state = .build(editor: editor, tool: tool)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return AreaBuildUtilitiesStateObserver(initialState: .empty(editor: nil))
    }()
    
    var graticuleIdentifier: SceneKitView.Graticule.CallbackReference?
}

extension AreaBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension AreaBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .empty(let editor):
                
                guard let editor = editor else { break }
                
                switch editor.meadow.scene.model.state {
                    
                case .scene(let world):
                    
                    world.blueprint.clear()
                    
                    editor.meadow.input.cursor.tracksIdleEvents = false
                    
                    if let graticuleIdentifier = self.graticuleIdentifier {
                        
                        editor.meadow.input.graticule.unsubscribe(graticuleIdentifier)
                    }
                    
                    self.graticuleIdentifier = nil
                    
                default: break
                }
                
            case .build(let editor, let tool):
                
                editor.meadow.input.cursor.tracksIdleEvents = true
                
                if self.graticuleIdentifier == nil {
                    
                    self.graticuleIdentifier = editor.meadow.input.graticule.subscribe(self.stateDidChange(from:to:))
                }
                
                self.edgeTypePopUp.removeAllItems()
                self.floorTypePopUp.removeAllItems()
                self.floorColorPalettePopUp.removeAllItems()
                self.internalMaterialPopUp.removeAllItems()
                self.internalColorPalettePopUp.removeAllItems()
                self.externalMaterialPopUp.removeAllItems()
                self.externalColorPalettePopUp.removeAllItems()
                
                self.externalEdgesButton.state = (tool.externalEdges ? .on : .off)
                
                AreaNodeEdgeType.allCases.forEach { edgeType in
                    
                    self.edgeTypePopUp.addItem(withTitle: edgeType.stringValue.capitalisingFirstLetter())
                }
                
                switch tool.edgeType {
                    
                case .door:
                    
                    if let index = AreaNodeEdgeType.allCases.firstIndex(of: AreaNodeEdgeType.CodingKeys.door) {
                        
                        self.edgeTypePopUp.selectItem(at: index)
                    }
                    
                case .wall:
                    
                    if let index = AreaNodeEdgeType.allCases.firstIndex(of: AreaNodeEdgeType.CodingKeys.wall) {
                        
                        self.edgeTypePopUp.selectItem(at: index)
                    }
                    
                case .window:
                    
                    if let index = AreaNodeEdgeType.allCases.firstIndex(of: AreaNodeEdgeType.CodingKeys.window) {
                        
                        self.edgeTypePopUp.selectItem(at: index)
                    }
                }
                
                AreaNodeFloorType.allCases.forEach { floorType in
                    
                    self.floorTypePopUp.addItem(withTitle: floorType.name)
                }
                
                if let index = AreaNodeFloorType.allCases.firstIndex(of: tool.floor.floorType) {
                    
                    self.floorTypePopUp.selectItem(at: index)
                    
                    self.floorColorPaletteView.colorPalette = tool.floor.colorPalette
                }
                else {
                    
                    self.floorColorPaletteView.colorPalette = nil
                }
                
                ArtDirector.shared?.palettes.children.forEach { palette in
                    
                    self.floorColorPalettePopUp.addItem(withTitle: palette.name)
                    self.internalColorPalettePopUp.addItem(withTitle: palette.name)
                    self.externalColorPalettePopUp.addItem(withTitle: palette.name)
                }
                
                if let index = ArtDirector.shared?.palettes.children.index(of: tool.floor.colorPalette) {
                    
                    self.floorColorPalettePopUp.selectItem(at: index)
                }
                
                AreaNodeEdgeMaterial.allCases.forEach { material in
                    
                    self.internalMaterialPopUp.addItem(withTitle: material.name)
                    self.externalMaterialPopUp.addItem(withTitle: material.name)
                }
                
                if let index = AreaNodeEdgeMaterial.allCases.firstIndex(of: tool.internalEdgeFace.material) {
                    
                    self.internalMaterialPopUp.selectItem(at: index)
                }
                
                if let index = AreaNodeEdgeMaterial.allCases.firstIndex(of: tool.externalEdgeFace.material) {
                    
                    self.externalMaterialPopUp.selectItem(at: index)
                }
                
                if let index = ArtDirector.shared?.palettes.children.index(of: tool.internalEdgeFace.colorPalette) {
                    
                    self.internalColorPalettePopUp.selectItem(at: index)
                    
                    self.internalColorPaletteView.colorPalette = tool.internalEdgeFace.colorPalette
                }
                
                if let index = ArtDirector.shared?.palettes.children.index(of: tool.externalEdgeFace.colorPalette) {
                    
                    self.externalColorPalettePopUp.selectItem(at: index)
                    
                    self.externalColorPaletteView.colorPalette = tool.externalEdgeFace.colorPalette
                }
            }
        }
    }
}

extension AreaBuildUtilitiesViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneKitView.GraticuleState?, to: SceneKitView.GraticuleState) {
        
        switch self.viewModel.state {
            
        case .build(let editor, let tool):
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                switch to {
                    
                case .tracking(let start, let end, _, let inputType):
                    
                    world.blueprint.clear()
                    
                    guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                    
                    var meshFaces: [MeshFace] = []
                    
                    var color = colorPalette.primary
                    
                    switch inputType {
                        
                    case .left: color = colorPalette.secondary
                    case .right: color = colorPalette.tertiary
                        
                    default: break
                    }
                    
                    let minimumX = min(start.coordinate.x, end.coordinate.x)
                    let maximumX = max(start.coordinate.x, end.coordinate.x)
                    let minimumZ = min(start.coordinate.z, end.coordinate.z)
                    let maximumZ = max(start.coordinate.z, end.coordinate.z)
                    
                    for x in minimumX...maximumX {
                        
                        for z in minimumZ...maximumZ {
                            
                            let coordinate = Coordinate(x: x, y: World.floor, z: z)
                            
                            if let terrainNode = world.terrain.find(node: coordinate) {
                                
                                let lowerPolytope = terrainNode.polyhedron.upperPolytope
                                
                                let upperPolytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY * MDWFloat(AreaNodeEdge.edgeHeight), z: 0.0))
                                
                                let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                                
                                GridEdge.Edges.forEach { edge in
                                    
                                    let corners = GridCorner.corners(edge: edge)
                                    
                                    let normal = GridEdge.normal(edge: edge)
                                    
                                    meshFaces.append(MeshFace.apex(corners: corners, polytope: polyhedron.upperPolytope, color: color.vector))
                                    
                                    meshFaces.append(contentsOf: MeshFace.edge(corners: corners, polyhedron: polyhedron, normal: normal, color: color.vector))
                                }
                            }
                        }
                    }
                    
                    world.blueprint.add(mesh: Mesh(faces: meshFaces))
                    
                case .up(let start, let end, _, let inputType):
                    
                    let minimumX = min(start.coordinate.x, end.coordinate.x)
                    let maximumX = max(start.coordinate.x, end.coordinate.x)
                    let minimumZ = min(start.coordinate.z, end.coordinate.z)
                    let maximumZ = max(start.coordinate.z, end.coordinate.z)
                    
                    for x in minimumX...maximumX {
                        
                        for z in minimumZ...maximumZ {
                            
                            let coordinate = Coordinate(x: x, y: start.coordinate.y, z: z)
                            
                            GridEdge.Edges.forEach { edge in
                                
                                switch inputType {
                                    
                                case .left:
                                    
                                    if world.terrain.find(node: coordinate) != nil {
                                        
                                        let areaNode = world.areas.add(node: coordinate)
                                        
                                        areaNode?.floor = tool.floor
                                        
                                        if tool.externalEdges {
                                            
                                            if x == minimumX {
                                                
                                                let _ = areaNode?.add(edge: .east, edgeType: tool.edgeType, internalEdgeFace: tool.internalEdgeFace, externalEdgeFace: tool.externalEdgeFace)
                                            }
                                            
                                            if x == maximumX {
                                                
                                                let _ = areaNode?.add(edge: .west, edgeType: tool.edgeType, internalEdgeFace: tool.internalEdgeFace, externalEdgeFace: tool.externalEdgeFace)
                                            }
                                            
                                            if z == minimumZ {
                                                
                                                let _ = areaNode?.add(edge: .south, edgeType: tool.edgeType, internalEdgeFace: tool.internalEdgeFace, externalEdgeFace: tool.externalEdgeFace)
                                            }
                                            
                                            if z == maximumZ {
                                                
                                                let _ = areaNode?.add(edge: .north, edgeType: tool.edgeType, internalEdgeFace: tool.internalEdgeFace, externalEdgeFace: tool.externalEdgeFace)
                                            }
                                        }
                                    }
                                    
                                case .right:
                                    
                                    if let areaNode = world.areas.find(node: coordinate) {
                                        
                                        world.areas.remove(node: areaNode)
                                    }
                                    
                                default: break
                                }
                            }
                        }
                    }
                    
                default: break
                }
                
            default: break
            }
            
        default: break
        }
    }
}
