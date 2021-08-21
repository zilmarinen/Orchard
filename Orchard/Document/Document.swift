//
//  Document.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Harvest
import SpriteKit

class Document: NSDocument {
    
    enum Constants {
        
        static let windowIndentifier = NSStoryboard.SceneIdentifier("WindowController")
        
        static let sceneGraphFileName = "scene"
        static let sceneGraphFileType = "graph"
    }
    
    let coordinator: WindowCoordinator
    
    var map: Map2D?

    override init() {
        
        guard let windowController = NSStoryboard.main.instantiateController(withIdentifier: Constants.windowIndentifier) as? WindowController else { fatalError("Invalid view controller hierarchy") }
        
        coordinator = WindowCoordinator(controller: windowController)
        
        super.init()
    }

    override class var autosavesInPlace: Bool {
        
        return true
    }

    override func makeWindowControllers() {
        
        self.addWindowController(coordinator.controller)
        
        coordinator.start(with: map)
                
        map = nil
    }

    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        
        guard let sceneGraph = fileWrapper.fileWrappers?.first(where: { $0.key == "\(Constants.sceneGraphFileName).\(Constants.sceneGraphFileType)" })?.value.regularFileContents else { throw NSError(domain: NSOSStatusErrorDomain, code: readErr, userInfo: nil) }
        
        let decoder = JSONDecoder()
        
        map = try decoder.decode(Map2D.self, from: sceneGraph)
    }
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        guard let scene = coordinator.splitViewCoordinator.spriteView?.scene as? Scene2D else { throw NSError(domain: NSOSStatusErrorDomain, code: writErr, userInfo: nil) }
        
        let encoder = JSONEncoder()
        
        var wrappers: [String : FileWrapper] = [:]
        
        let sceneGraph = try encoder.encode(scene.map)
        
        wrappers["\(Constants.sceneGraphFileName).\(Constants.sceneGraphFileType)"] = FileWrapper(regularFileWithContents: sceneGraph)
        
        return FileWrapper(directoryWithFileWrappers: wrappers)
    }
}
