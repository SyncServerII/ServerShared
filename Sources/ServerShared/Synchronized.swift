//
//  Synchronized.swift
//  Server
//
//  Created by Christopher G Prince on 12/28/17.
//

import Foundation
import Dispatch

public class Synchronized {
    private let semaphore = DispatchSemaphore(value: 1)
    
    public init() {
    }
    
    public func sync(closure:()->()) {
        semaphore.wait()
        closure()
        semaphore.signal()
    }
    
    public func sync(closure: () throws -> ()) throws {
        // NOTE: Can't do this as rethrows because throwing an error while holding a semaphore causes a crash.
        
        var throwError: Error?
        
        semaphore.wait()
        do {
            try closure()
        } catch let error {
            throwError = error
        }
        semaphore.signal()
        
        if let throwError = throwError {
            throw throwError
        }
    }
}

