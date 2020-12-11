//
//  Inspector.swift
//  Orchard
//
//  Created by Zack Brown on 04/12/2020.
//

protocol Inspector {
    
    associatedtype T
    
    var inspectable: T? { get }
    
    func refresh()
}
