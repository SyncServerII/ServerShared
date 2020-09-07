//
//  Async.swift
//  Server
//
//  Created by Christopher Prince on 6/10/17.
//
//

import Foundation
import Dispatch
        
// Patterned partly after https://www.raywenderlich.com/5371-grand-central-dispatch-tutorial-for-swift-4-part-2-2#toc-anchor-002
public extension Sequence {
    // Synchronously run the asynchronous apply method on each element in the sequence. stopAtFirstError determines whether this stops at the first error, if any, or continues despite errors.
    // If the errors array is empty on return, there were no errors.
    func synchronouslyRun<R>(stopAtFirstError: Bool = true, apply: (_ element: Element, _ completion: @escaping (Swift.Result<R, Error>)->())->()) -> ([R], [Swift.Error]) {
    
        let group = DispatchGroup()
    
        var resultErrors = [Error]()
        var resultSuccess = [R]()

        for element in self {
            group.enter()
            apply(element) { result in
                switch result {
                case .success(let s):
                    resultSuccess += [s]
                case .failure(let error):
                    resultErrors += [error]
                }
                group.leave()
            }
            group.wait()
            
            if resultErrors.count > 0 && stopAtFirstError {
                break
            }
        }
        
        return (resultSuccess, resultErrors)
    }
}
