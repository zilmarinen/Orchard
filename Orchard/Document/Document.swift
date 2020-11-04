//
//  Document.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow

class Document: NSDocument {
    
    enum Constants {
        
        static let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        static let windowIndentifier = NSStoryboard.SceneIdentifier("WindowController")
        
        static let sceneGraphWrapperIdentifier = "scene.graph"
    }
    
    let coordinator: WindowCoordinator
    
    var scene: Scene?

    override init() {
        
        guard let windowController = Constants.storyboard.instantiateController(withIdentifier: Constants.windowIndentifier) as? WindowController else { fatalError("Invalid view controller hierarchy") }
        
        coordinator = WindowCoordinator(controller: windowController)
        
        super.init()
    }

    override class var autosavesInPlace: Bool {
        
        return true
    }

    override func makeWindowControllers() {
        
        self.addWindowController(coordinator.controller)
        
        coordinator.start(with: scene)
        
        scene = nil
    }

    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        
        guard let sceneGraph = fileWrapper.fileWrappers?.first(where: { $0.key == Constants.sceneGraphWrapperIdentifier })?.value.regularFileContents else { throw NSError(domain: NSOSStatusErrorDomain, code: readErr, userInfo: nil) }
        
        let decoder = JSONDecoder()
        
        self.scene = decoder.decode(Scene.self, from: sceneGraph)
    }
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        guard let scene = coordinator.splitViewCoordinator.sceneCoordinator.controller.sceneView.scene as? Scene else { throw NSError(domain: NSOSStatusErrorDomain, code: writErr, userInfo: nil) }
        
        let encoder = JSONEncoder()
        
        var wrappers: [String : FileWrapper] = [:]
        
        let sceneGraph = try encoder.encode(scene)
        
        wrappers[Constants.sceneGraphWrapperIdentifier] = FileWrapper(regularFileWithContents: sceneGraph)
        
        return FileWrapper(directoryWithFileWrappers: wrappers)
    }
}
