//
//  File.swift
//  
//
//  Created by Thomas Kalhøj Clemensen on 13/08/2020.
//

import Foundation
@testable import TriforkSwiftDependencyInjection

protocol Bread { }

struct Croissant : Bread { }
struct PainAuChocolat : Bread { }

public struct Tester {
    @Inject var bread: Bread
    @Inject("🥐") var breadKey: Bread
}
