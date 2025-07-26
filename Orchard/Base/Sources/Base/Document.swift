 //
//  Document.swift
//  Base
//
//  Created by Zack Brown on 11/07/2025.
//

import Cocoa
import Deltille
import UniformTypeIdentifiers

public class Document: NSDocument {
    
    public override class var autosavesInPlace: Bool { true }
    public override nonisolated var isEntireFileLoaded: Bool { true }
    public override class var readableTypes: [String] { [UTType.documentReadableType.identifier] }
    public override class var writableTypes: [String] { [UTType.documentWriteableType.identifier] }
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var regions: [Coordinate : RegionIntermediate]
    private var zones: [Coordinate : ZoneIntermediate]
    
    public var regionIntermediates: [RegionIntermediate]? { Array(regions.values) }
    public var zoneIntermediates: [ZoneIntermediate]? { Array(zones.values) }
    
    override init() {
        
        self.regions = [.zero : .init(coordinate: .zero)]
        self.zones = [.zero : .init(coordinate: .zero)]
        
        super.init()
    }
    
    public override func makeWindowControllers() {
        
        let storyboard = NSStoryboard(name: NSStoryboard.main,
                                      bundle: nil)
        
        guard let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.scene) as? NSWindowController else { fatalError("Invalid window controller") }
        
        addWindowController(windowController)
    }

    public override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        let world = WorldIntermediate(regions: Array(regions.keys),
                                      zones: Array(zones.keys))
        
        var package: [String : FileWrapper] = [:]
        
        // MARK: World
        
        package.write(value: FileWrapper(regularFileWithContents: try encoder.encode(world)),
                           forKey: .world)
        
        // MARK: Regions
        
        let regionsFileWrappers = try regions.reduce(into: [String : FileWrapper]()) { result, region in
            
            let data = try encoder.encode(region.value)
            
            result.write(value: .init(regularFileWithContents: data),
                         forKey: .region(coordinate: region.key))
        }
        
        package.write(value: .init(directoryWithFileWrappers: regionsFileWrappers),
                           forKey: .regions)
        
        // MARK: Zones
        
        let zonesFileWrappers = try zones.reduce(into: [String : FileWrapper]()) { result, zone in
            
            
            let data = try encoder.encode(zone.value)
            
            result.write(value: .init(regularFileWithContents: data),
                         forKey: .zone(coordinate: zone.key))
        }
        
        package.write(value: .init(directoryWithFileWrappers: zonesFileWrappers),
                      forKey: .zones)
        
        return FileWrapper(directoryWithFileWrappers: package)
    }
    
    public override func read(from fileWrapper: FileWrapper,
                              ofType typeName: String) throws {
        
        guard let worldData = fileWrapper.regularFileContents(forKey: .world),
              let regionsFileWrapper = fileWrapper.fileWrapper(forKey: .regions),
              let zonesFileWrapper = fileWrapper.fileWrapper(forKey: .zones) else { throw CocoaError(.fileReadNoSuchFile) }
        
        // MARK: World
        
        let world = try decoder.decode(WorldIntermediate.self,
                                       from: worldData)
        
        // MARK: Regions
        
        self.regions = try world.regions.reduce(into: [:]) { result, coordinate in
            
            guard let regionData = regionsFileWrapper.regularFileContents(forKey: .region(coordinate: coordinate)) else { throw CocoaError(.fileReadNoSuchFile) }
            
            result[coordinate] = try decoder.decode(RegionIntermediate.self,
                                                    from: regionData)
        }
        
        // MARK: Zones
        
        self.zones = try world.zones.reduce(into: [:]) { result, coordinate in
        
            guard let zoneData = zonesFileWrapper.regularFileContents(forKey: .zone(coordinate: coordinate)) else { throw CocoaError(.fileReadNoSuchFile) }
            
            result[coordinate] = try decoder.decode(ZoneIntermediate.self,
                                                    from: zoneData)
        }
    }
}

extension Document {
    
    public func regionIntermediate(for coordinate: Coordinate) -> RegionIntermediate? {
        
        regions[coordinate]
    }
}
