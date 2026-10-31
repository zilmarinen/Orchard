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
        case region(triangle: Triangle)
        case zone(triangle: Triangle)
    }
    
    public override class var autosavesInPlace: Bool { true }
    public override nonisolated var isEntireFileLoaded: Bool { true }
    public override class var readableTypes: [String] { [UTType.documentReadableType.identifier] }
    public override class var writableTypes: [String] { [UTType.documentWriteableType.identifier] }
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    nonisolated(unsafe) private(set) public var regionIntermediates: [Triangle : RegionIntermediate] = [:]
    nonisolated(unsafe) private(set) public var zoneIntermediates: [Triangle : ZoneIntermediate] = [:]
    
    nonisolated(unsafe) private(set) var regions: [Triangle : Data] = [:]
    nonisolated(unsafe) private(set) var zones: [Triangle : Data] = [:]
    
    public override func makeWindowControllers() {
        
        let storyboard = NSStoryboard(name: NSStoryboard.main,
                                      bundle: nil)
        
        guard let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.scene) as? NSWindowController else { fatalError("Invalid window controller") }
        
        addWindowController(windowController)
    }

    public override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        let world = WorldIntermediate(regions: Array(regionIntermediates.values),
                                      zones: Array(zoneIntermediates.values))
        
        var package: [String : FileWrapper] = [:]
        
        // MARK: World
        
        package.write(value: .init(regularFileWithContents: try encoder.encode(world)),
                      forKey: .world)
        
        // MARK: Regions
        
        let regionFileWrappers = regions.reduce(into: [String : FileWrapper]()) { result, region in
            
            result.write(value: .init(regularFileWithContents: region.value),
                         forKey: .region(triangle: region.key))
        }
        
        package.write(value: .init(directoryWithFileWrappers: regionFileWrappers),
                           forKey: .regions)
        
        // MARK: Zones
        
        let zoneFileWrappers = zones.reduce(into: [String : FileWrapper]()) { result, zone in
            
            result.write(value: .init(regularFileWithContents: zone.value),
                         forKey: .zone(triangle: zone.key))
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
         
            result[intermediate.triangle] = intermediate
        }
        
        self.zoneIntermediates = world.zones.reduce(into: [:]) { result, intermediate in
         
            result[intermediate.triangle] = intermediate
        }
        
        // MARK: Regions
        
        self.regions = try world.regions.reduce(into: [:]) { result, intermediate in
            
            guard let regionData = regionFileWrapper.regularFileContents(forKey: .region(triangle: intermediate.triangle)) else { throw CocoaError(.fileReadNoSuchFile) }
            
            result[intermediate.triangle] = regionData
        }
        
        // MARK: Zones
        
        self.zones = try world.zones.reduce(into: [:]) { result, intermediate in
        
            guard let zoneData = zoneFileWrapper.regularFileContents(forKey: .zone(triangle: intermediate.triangle)) else { throw CocoaError(.fileReadNoSuchFile) }
            
            result[intermediate.triangle] = zoneData
        }
    }
}

extension Document {
    
    // MARK: Region Intermediate
    
    public func region(intermediate triangle: Triangle) -> RegionIntermediate? {
        
        regionIntermediates[triangle]
    }
    
    public func update(region triangle: Triangle,
                       identifier: String) {
        
        regionIntermediates[triangle]?.identifier = identifier
    }
    
    // MARK: Zone Intermediate
    
    public func zone(intermediate triangle: Triangle) -> ZoneIntermediate? {
        
        zoneIntermediates[triangle]
    }
    
    public func update(zone triangle: Triangle,
                       identifier: String) {
        
        zoneIntermediates[triangle]?.identifier = identifier
    }
    
    // MARK: Regions
    
    public func region(for triangle: Triangle) throws -> Region? {
        
        guard let data = regions[triangle] else { return nil }
        
        return try decoder.decode(Region.self,
                                  from: data)
    }
    
    public func create(region triangle: Triangle,
                       identifier: String? = nil) throws -> Region {
        
        let intermediate = RegionIntermediate(triangle,
                                              identifier)
        let region = Region(empty: triangle)
        
        regionIntermediates[triangle] = intermediate
        regions[triangle] = try encoder.encode(region)
        
        return region
    }
    
    public func delete(region triangle: Triangle) throws {
        
        guard regions[triangle] != nil || regionIntermediates[triangle] != nil else { return }
        
        regionIntermediates[triangle] = nil
        regions[triangle] = nil
        
        let sieve = triangle.sieve(.region)
        
        for adjacent in triangle.disc(1) {
            
            guard let neighbour = try region(for: adjacent) else { continue }
            
            neighbour.remove(values: sieve)
            
            try save(region: neighbour)
        }
    }
    
    public func save(region: Region) throws {
        
        guard !region.isEmpty else {
            
            return try delete(region: region.triangle)
        }
        
        regions[region.triangle] = try encoder.encode(region)
        
        guard regionIntermediates[region.triangle] == nil else { return }
        
        regionIntermediates[region.triangle] = .init(region.triangle)
    }
    
//    // MARK: Zones
//    
//    public func zone(for triangle: Triangle) throws -> RegionSlice? {
//
//        guard let data = zones[triangle] else { return nil }
//
//        return try decoder.decode(RegionSlice.self,
//                                  from: data)
//    }
//    
//    public func create(zone triangle: Triangle,
//                       identifier: String? = nil) throws -> RegionSlice {
//        
//        let intermediate = ZoneIntermediate(triangle,
//                                            identifier)
//        let region = RegionSlice(empty: triangle)
//
//        zoneIntermediates[triangle] = intermediate
//        zones[triangle] = try encoder.encode(region)
//
//        return region
//    }
//    
//    public func delete(zone triangle: Triangle) throws {
//
//        guard zones[triangle] != nil || zoneIntermediates[triangle] != nil else { return }
//
//        zoneIntermediates[triangle] = nil
//        zones[triangle] = nil
//        
//        let sieve = triangle.sieve(for: .region)
//        
//        for adjacent in triangle.perimeter {
//            
//            guard let neighbour = try zone(for: adjacent.triangle) else { continue }
//
//            neighbour.remove(values: sieve)
//            
//            try save(zone: neighbour)
//        }
//    }
//    
//    public func save(zone: RegionSlice) throws {
//        
//        guard !zone.isEmpty else {
//            
//            return try delete(zone: zone.triangle)
//        }
//        
//        zones[zone.triangle] = try encoder.encode(zone)
//
//        guard zoneIntermediates[zone.triangle] == nil else { return }
//
//        zoneIntermediates[zone.triangle] = .init(zone.triangle)
//    }
}
