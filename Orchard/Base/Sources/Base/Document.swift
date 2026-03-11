 //
//  Document.swift
//
//  Created by Zack Brown on 11/07/2025.
//

import Cocoa
import Deltille
import Harvest
import UniformTypeIdentifiers

@MainActor
public final class Document: NSDocument {
    
    public enum Selection {
        
        case none
        case region(vertex: Triangle.Vertex)
        case zone(vertex: Triangle.Vertex)
    }
    
    public override class var autosavesInPlace: Bool { true }
    public override nonisolated var isEntireFileLoaded: Bool { true }
    public override class var readableTypes: [String] { [UTType.documentReadableType.identifier] }
    public override class var writableTypes: [String] { [UTType.documentWriteableType.identifier] }
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    nonisolated(unsafe) private(set) var regions: [Triangle.Vertex : Region]
    nonisolated(unsafe) private(set) var zones: [Triangle.Vertex : ZoneIntermediate]
    
    public var regionIntermediates: [Region] { Array(regions.values) }
    public var zoneIntermediates: [ZoneIntermediate] { Array(zones.values) }
    
    override init() {
        
        self.regions = [.zero : .init(empty: .zero,
                                     identifier: "Origin")]
        self.zones = [:]
        
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
        
        package.write(value: .init(regularFileWithContents: try encoder.encode(world)),
                      forKey: .world)
        
        // MARK: Regions
        
        let regionsFileWrappers = try regions.reduce(into: [String : FileWrapper]()) { result, region in
            
            let data = try encoder.encode(region.value)
            
            result.write(value: .init(regularFileWithContents: data),
                         forKey: .region(vertex: region.key))
        }
        
        package.write(value: .init(directoryWithFileWrappers: regionsFileWrappers),
                           forKey: .regions)
        
        // MARK: Zones
        
        let zonesFileWrappers = try zones.reduce(into: [String : FileWrapper]()) { result, zone in
            
            
            let data = try encoder.encode(zone.value)
            
            result.write(value: .init(regularFileWithContents: data),
                         forKey: .zone(vertex: zone.key))
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
        
        self.regions = try world.regions.reduce(into: [:]) { result, vertex in
            
            guard let regionData = regionsFileWrapper.regularFileContents(forKey: .region(vertex: vertex)) else { throw CocoaError(.fileReadNoSuchFile) }
            
            result[vertex] = try decoder.decode(Region.self,
                                                from: regionData)
        }
        
        // MARK: Zones
        
        self.zones = try world.zones.reduce(into: [:]) { result, vertex in
        
            guard let zoneData = zonesFileWrapper.regularFileContents(forKey: .zone(vertex: vertex)) else { throw CocoaError(.fileReadNoSuchFile) }
            
            result[vertex] = try decoder.decode(ZoneIntermediate.self,
                                                from: zoneData)
        }
    }
}

extension Document {
    
    // MARK: Regions
    
    public func region(for vertex: Triangle.Vertex) -> Region? {
        
        regions[vertex]
    }
    
    public func create(region vertex: Triangle.Vertex) -> Region {
        
        let region = Region(empty: .init(vertex))
        
        regions[vertex] = region
        
        return region
    }
    
    public func save(region: Region) {
        
        guard !region.isEmpty else {
            
            return delete(region: region.origin)
        }
        
        regions[region.origin] = region
    }
    
    public func delete(region vertex: Triangle.Vertex) {
        
        regions[vertex] = nil
        
        let triangle = Triangle(vertex)
        
        for adjacent in triangle.perimeter {
            
            guard let region = region(for: adjacent.vertex) else { continue }
            
            region.remove(tiles: triangle)
        }
    }
    
    // MARK: Zones
    
    public func zone(for vertex: Triangle.Vertex) -> ZoneIntermediate? {
        
        zones[vertex]
    }
    
    public func create(zone vertex: Triangle.Vertex) -> ZoneIntermediate {
        
        let zone = ZoneIntermediate(origin: vertex)
        
        zones[vertex] = zone
        
        return zone
    }
    
    public func delete(zone vertex: Triangle.Vertex) {
        
        zones[vertex] = nil
    }
}
