//
//  Document.swift
//  Orchard
//
//  Created by Zack Brown on 23/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class Document: NSDocument {
    
    struct DocumentJSON: StartOption, Decodable {
        
        let graph: Graph
        let meadow: MeadowJSON?
    }
    
    let coordinator: WindowCoordinator
    
    var json: DocumentJSON?

    override init() {
        
        let controller = NSStoryboard.main!.instantiateController(withIdentifier: OrchardWindowController.sceneIdentifier) as! OrchardWindowController
        
        self.coordinator = WindowCoordinator(controller: controller)
        
        super.init()
    }
    
    override class var autosavesInPlace: Bool {
        
        return true
    }
    
    override func makeWindowControllers() {
        
        self.addWindowController(coordinator.controller)
        
        if json == nil {
            
            let plotter = HexGraph(rings: 3, size: 1.0)
            
            let resolver = LaplacianResolver(iterations: 1)
            
            let graph = Graph(plotter: plotter, resolver: resolver)
        
            json = DocumentJSON(graph: graph, meadow: nil)
        }
        
        coordinator.start(with: json)
        
        json = nil
    }
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        guard let meadow = coordinator.orchardCoordinator.scene?.meadow else { throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": "Unable to find valid instance of Meadow."]) }
        
        let encoder = JSONEncoder()
        
        var wrappers: [String : FileWrapper] = [:]
        
        let meadowData = try encoder.encode(meadow)
        let graphData = try encoder.encode(meadow.graph)
        
        wrappers["world.meadow"] = FileWrapper(regularFileWithContents: meadowData)
        wrappers["scene.graph"] = FileWrapper(regularFileWithContents: graphData)
        
        return FileWrapper(directoryWithFileWrappers: wrappers)
    }
    
    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        
        do {
            
            let graphWrapper = fileWrapper.fileWrappers?.first { $0.key.hasSuffix(".graph") }?.value
            let meadowWrapper = fileWrapper.fileWrappers?.first { $0.key.hasSuffix(".meadow") }?.value
            
            guard let graphData = graphWrapper?.regularFileContents, let meadowData = meadowWrapper?.regularFileContents else {
                
                throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": "Unable to load contents of file wrapper."])
            }
            
            let decoder = JSONDecoder()
            
            let graph = try decoder.decode(Graph.self, from: graphData)
            let meadowJSON = try decoder.decode(MeadowJSON.self, from: meadowData)
            
            self.json = DocumentJSON(graph: graph, meadow: meadowJSON)
        }
        catch {
            
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": error])
        }
    }
}
