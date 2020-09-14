
import Foundation

public enum Partition {    
    public static func array<E, P: Comparable>(_ array: [E], using keyPath: KeyPath<E, P>) -> [[E]] {
        guard array.count > 0 else {
            return [[]]
        }

        let sorted = array.sorted { du1, du2  in
            let value1 = du1[keyPath: keyPath]
            let value2 = du2[keyPath: keyPath]
            return value1 < value2
        }
        
        // Each sub-array has the same value for keyPath
        var aggregated = [[E]]()
                
        var current = [E]()
        var currentKeyValue: P?
        for element in sorted {
            if let keyValue = currentKeyValue {
                if keyValue == element[keyPath: keyPath] {
                    current += [element]
                }
                else {
                    currentKeyValue = element[keyPath: keyPath]
                    aggregated += [current]
                    current = [element]
                }
            }
            else {
                currentKeyValue = element[keyPath: keyPath]
                current += [element]
            }
        }
        
        aggregated += [current]
        return aggregated
    }
    
    // Partition the array by distinct values for the keypath
    public static func array<E, P: Comparable>(_ array: [E], using keyPath: KeyPath<E, P?>) -> [[E]] {
    
        guard array.count > 0 else {
            return [[]]
        }
        
        // Each sub-array has the same value for keyPath
        var aggregated = [[E]]()

        let sorted = array.sorted { du1, du2  in
            guard let value1 = du1[keyPath: keyPath],
                let value2 = du2[keyPath: keyPath] else {
                return false
            }
            return value1 < value2
        }
        
        var current = [E]()
        var currentKeyValue: P?
        for element in sorted {
            if let keyValue = currentKeyValue {
                if keyValue == element[keyPath: keyPath] {
                    current += [element]
                }
                else {
                    currentKeyValue = element[keyPath: keyPath]
                    aggregated += [current]
                    current = [element]
                }
            }
            else {
                currentKeyValue = element[keyPath: keyPath]
                current += [element]
            }
        }
        
        aggregated += [current]
        return aggregated
    }
}
