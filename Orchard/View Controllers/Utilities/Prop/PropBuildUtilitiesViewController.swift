//
//  PropBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class PropBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var propTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var propListPopUp: NSPopUpButton!
    
    @IBOutlet weak var propPopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var rotationPopUp: NSPopUpButton!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, var tool):
            
            switch sender {
                
            case propTypePopUp:
                
                guard let propType = PropType(rawValue: sender.indexOfSelectedItem) else { break }
                
                let propLists = PropsMaster.shared?.lists(type: propType)
                
                if let propList = propLists?.first, let prop = propList.child(at: 0) {
                
                    tool.propType = propType
                    tool.propList = propList
                    tool.prop = prop
                }
                
            case propListPopUp:
                
                guard let propList = PropsMaster.shared?.lists(type: tool.propType)[sender.indexOfSelectedItem], let prop = propList.child(at: 0) else { break }
                
                tool.propList = propList
                tool.prop = prop
                
            case propPopUp:
                
                guard let prop = tool.propList.child(at: sender.indexOfSelectedItem) else { break }
                
                tool.prop = prop
                
            case colorPalettePopUp:
                
               guard let colorPalette = ArtDirector.shared?.palettes.children[sender.indexOfSelectedItem] else { break }
                
                tool.colorPalette = colorPalette
                
            case rotationPopUp:
                
                guard let rotation = GridEdge(rawValue: sender.indexOfSelectedItem) else { break }
                
                tool.rotation = rotation
                
            default: break
            }
         
            viewModel.state = .build(editor: editor, tool: tool)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return PropBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var graticuleIdentifier: SceneKitView.Graticule.CallbackReference?
}

extension PropBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension PropBuildUtilitiesViewController {
    
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
                
                self.propTypePopUp.removeAllItems()
                self.propListPopUp.removeAllItems()
                self.propPopUp.removeAllItems()
                self.colorPalettePopUp.removeAllItems()
                self.rotationPopUp.removeAllItems()
                
                PropType.allCases.forEach { propType in
                    
                    self.propTypePopUp.addItem(withTitle: propType.name)
                }
                
                if let index = PropType.allCases.firstIndex(of: tool.propType) {
                    
                    self.propTypePopUp.selectItem(at: index)
                }
                
                let propLists = PropsMaster.shared?.lists(type: tool.propType)
                
                propLists?.forEach { propList in
                    
                    self.propListPopUp.addItem(withTitle: propList.name)
                }
                
                if let index = propLists?.firstIndex(of: tool.propList) {
                    
                    self.propListPopUp.selectItem(at: index)
                }
                
                for index in 0..<tool.propList.totalChildren {
                    
                    if let prop = tool.propList.child(at: index) {
                        
                        self.propPopUp.addItem(withTitle: prop.name)
                    }
                }
                
                if let index = tool.propList.index(of: tool.prop) {
                    
                    self.propPopUp.selectItem(at: index)
                }
                
                ArtDirector.shared?.palettes.children.forEach { palette in
                    
                    self.colorPalettePopUp.addItem(withTitle: palette.name)
                }
                
                if let index = ArtDirector.shared?.palettes.children.index(of: tool.colorPalette) {
                    
                    self.colorPalettePopUp.selectItem(at: index)
                    
                    self.colorPaletteView.colorPalette = tool.colorPalette
                }
                else {
                    
                    self.colorPaletteView.colorPalette = nil
                }
                
                GridEdge.Edges.forEach { edge in
                    
                    self.rotationPopUp.addItem(withTitle: edge.description)
                }
                
                self.rotationPopUp.selectItem(at: tool.rotation.rawValue)
            }
        }
    }
}


extension PropBuildUtilitiesViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneKitView.GraticuleState?, to: SceneKitView.GraticuleState) {
        
        switch self.viewModel.state {
            
        case .build(let editor, let tool):
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                switch to {
                    
                case .up(_, let end, _, let inputType):
                    
                    if inputType == .left {
                        
                        let prop = world.props.add(prototype: tool.prop, coordinate: end.coordinate, rotation: tool.rotation)
                        
                        prop?.colorPalette = tool.colorPalette
                    }
                    
                case .tracking(_, let end, _, _):
                    
                    world.blueprint.clear()
                    
                    guard world.terrain.find(node: end.coordinate) != nil else { break }
                    
                    var meshFaces: [MeshFace] = []
                    
                    var color = tool.colorPalette.primary
                    
                    let footprint = Footprint(coordinate: end.coordinate, rotation: tool.rotation, nodes: tool.prop.footprint.nodes)
                    
                    if world.props.find(prop: footprint) != nil {
                        
                        color = tool.colorPalette.tertiary
                    }
                    else {
                        
                        color = tool.colorPalette.secondary
                    }
                    
                    footprint.nodes.forEach { footprintNode in
                        
                        let lowerPolytope = Polytope(x: MDWFloat(footprintNode.coordinate.x), y0: footprintNode.coordinate.y, y1: footprintNode.coordinate.y, y2: footprintNode.coordinate.y, y3: footprintNode.coordinate.y, z: MDWFloat(footprintNode.coordinate.z))
                        
                        let upperPolytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY, z: 0.0))
                        
                        let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                        
                        footprintNode.edges.forEach { edge in
                            
                            let corners = GridCorner.corners(edge: edge)
                            
                            let normal = GridEdge.normal(edge: edge)
                            
                            meshFaces.append(MeshFace.apex(corners: corners, polytope: polyhedron.upperPolytope, color: color.vector))
                            
                            meshFaces.append(contentsOf: MeshFace.edge(corners: corners, polyhedron: polyhedron, normal: normal, color: color.vector))
                        }
                    }
                    
                    world.blueprint.add(mesh: Mesh(faces: meshFaces))
                    
                default: break
                }
                
            default: break
            }

        default: break
        }
    }
}

