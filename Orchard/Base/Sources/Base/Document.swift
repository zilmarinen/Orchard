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
    
    nonisolated(unsafe) private(set) public var regionIntermediates: [Triangle.Vertex : RegionIntermediate] = [:]
    nonisolated(unsafe) private(set) public var zoneIntermediates: [Triangle.Vertex : ZoneIntermediate] = [:]
    
    nonisolated(unsafe) private(set) var regions: [Triangle.Vertex : Region] = [:]
    nonisolated(unsafe) private(set) var zones: [Triangle.Vertex : Region] = [:]
    
    public override func makeWindowControllers() {
        
        let storyboard = NSStoryboard(name: NSStoryboard.main,
                                      bundle: nil)
        
        guard let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.scene) as? NSWindowController else { fatalError("Invalid window controller") }
        
        addWindowController(windowController)
        
        guard regionIntermediates.isEmpty else { return }
        
        create(empty: .zero,
               identifier: "Origin")
    }

    public override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        let world = WorldIntermediate(regions: Array(regionIntermediates.values),
                                      zones: Array(zoneIntermediates.values))
        
        var package: [String : FileWrapper] = [:]
        
        // MARK: World
        
        package.write(value: .init(regularFileWithContents: try encoder.encode(world)),
                      forKey: .world)
        
        // MARK: Regions
        
        let regionFileWrappers = try regions.reduce(into: [String : FileWrapper]()) { result, region in
            
            let data = try encoder.encode(region.value)
            
            result.write(value: .init(regularFileWithContents: data),
                         forKey: .region(vertex: region.key))
        }
        
        package.write(value: .init(directoryWithFileWrappers: regionFileWrappers),
                           forKey: .regions)
        
        // MARK: Zones
        
        let zoneFileWrappers = try zones.reduce(into: [String : FileWrapper]()) { result, zone in
            
            
            let data = try encoder.encode(zone.value)
            
            result.write(value: .init(regularFileWithContents: data),
                         forKey: .zone(vertex: zone.key))
        }
        
        package.write(value: .init(directoryWithFileWrappers: zoneFileWrappers),
                      forKey: .zones)
        
        return FileWrapper(directoryWithFileWrappers: package)
    }
    
    public override func read(from fileWrapper: FileWrapper,
                              ofType typeName: String) throws {
        
        guard let worldData = fileWrapper.regularFileContents(forKey: .world),
              let regionFileWrapper = fileWrapper.fileWrapper(forKey: .regions),
              let zoneFileWrapper = fileWrapper.fileWrapper(forKey: .zones) else { throw CocoaError(.fileReadNoSuchFile) }
        
        // MARK: World
        
        let world = try decoder.decode(WorldIntermediate.self,
                                       from: worldData)
        
        self.regionIntermediates = world.regions.reduce(into: [:]) { result, intermediate in
         
            result[intermediate.vertex] = intermediate
        }
        
        self.zoneIntermediates = world.zones.reduce(into: [:]) { result, intermediate in
         
            result[intermediate.vertex] = intermediate
        }
        
        // MARK: Regions
        
        self.regions = try world.regions.reduce(into: [:]) { result, intermediate in
            
            guard let regionData = regionFileWrapper.regularFileContents(forKey: .region(vertex: intermediate.vertex)) else { throw CocoaError(.fileReadNoSuchFile) }
            
            result[intermediate.vertex] = try decoder.decode(Region.self,
                                                             from: regionData)
        }
        
        // MARK: Zones
        
        self.zones = try world.zones.reduce(into: [:]) { result, intermediate in
        
            guard let zoneData = zoneFileWrapper.regularFileContents(forKey: .zone(vertex: intermediate.vertex)) else { throw CocoaError(.fileReadNoSuchFile) }
            
            result[intermediate.vertex] = try decoder.decode(Region.self,
                                                             from: zoneData)
        }
    }
}

extension Document {
    
    // MARK: Region Intermediate
    
    public func region(intermediate vertex: Triangle.Vertex) -> RegionIntermediate? {
        
        regionIntermediates[vertex]
    }
    
    public func update(region vertex: Triangle.Vertex,
                       identifier: String) {
        
        regionIntermediates[vertex]?.identifier = identifier
    }
    
    // MARK: Zone Intermediate
    
    public func zone(intermediate vertex: Triangle.Vertex) -> ZoneIntermediate? {
        
        zoneIntermediates[vertex]
    }
    
    public func update(zone vertex: Triangle.Vertex,
                       identifier: String) {
        
        zoneIntermediates[vertex]?.identifier = identifier
    }
    
    // MARK: Regions
    
    public func region(for vertex: Triangle.Vertex) -> Region? {
        
        regions[vertex]
    }
    
    private func create(empty region: Triangle,
                        identifier: String? = nil) {
        
        regionIntermediates[region.vertex] = RegionIntermediate(region.vertex,
                                                                identifier)
        regions[region.vertex] = Region(empty: region)
    }
    
    public func create(region vertex: Triangle.Vertex) -> Region {
        
        let intermediate = RegionIntermediate(vertex)
        let region = Region(empty: .init(vertex))
        
        regionIntermediates[vertex] = intermediate
        regions[vertex] = region
        
        return region
    }
    
    public func delete(region vertex: Triangle.Vertex) {
        
        guard regions[vertex] != nil || regionIntermediates[vertex] != nil else { return }
        
        regionIntermediates[vertex] = nil
        regions[vertex] = nil
        
        let region = Triangle(vertex)
        
        for adjacent in region.perimeter {
            
            guard let neighbour = self.region(for: adjacent.vertex) else { continue }
            
            neighbour.remove(tiles: region)
        }
    }
    
    public func save(region: Region) {
        
        guard !region.isEmpty else {
            
            return delete(region: region.vertex)
        }
        
        regions[region.vertex] = region
        
        guard regionIntermediates[region.vertex] == nil else { return }
        
        regionIntermediates[region.vertex] = .init(region.vertex)
    }
    
    // MARK: Zones
    
    public func zone(for vertex: Triangle.Vertex) -> Region? {
        
        zones[vertex]
    }
    
    public func create(zone vertex: Triangle.Vertex) -> Region {
        
        let intermediate = ZoneIntermediate(vertex)
        let zone = Region(empty: .init(vertex))
        
        zoneIntermediates[vertex] = intermediate
        zones[vertex] = zone
        
        return zone
    }
    
    public func delete(zone vertex: Triangle.Vertex) {
        
        guard zones[vertex] != nil || zoneIntermediates[vertex] != nil else { return }
        
        zoneIntermediates[vertex] = nil
        zones[vertex] = nil
        
        let region = Triangle(vertex)
        
        for adjacent in region.perimeter {
            
            guard let neighbour = self.zone(for: adjacent.vertex) else { continue }
            
            neighbour.remove(tiles: region)
        }
    }
    
    public func save(zone: Region) {
        
        guard !zone.isEmpty else {
            
            return delete(zone: zone.vertex)
        }
        
        zones[zone.vertex] = zone
        
        guard zoneIntermediates[zone.vertex] == nil else { return }
        
        zoneIntermediates[zone.vertex] = .init(zone.vertex)
    }
}
