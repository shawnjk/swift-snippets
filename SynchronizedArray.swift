import UIKit

// WARNING: THIS DOESN'T WORK -- JUST AN EXAMPLE OF HOW TO IMPLEMENT COLLECTIONS

struct SynchronizedArray<Element: Hashable> {
    var realArray: [Element] = []
    let dispatchQueue = DispatchQueue(label: UUID().uuidString)
}

extension SynchronizedArray: Collection {
    typealias Index = Int
    typealias Iterator = IndexingIterator<Array<Element>>

    func makeIterator() -> IndexingIterator<Array<Element>> {
        return realArray.makeIterator()
    }


    var startIndex: Index {
        return realArray.startIndex
    }

    var endIndex: Index {
        return realArray.endIndex
    }

    func index(after i: Index) -> Index {
        return realArray.index(after: i)
    }
}

extension SynchronizedArray: MutableCollection {
    subscript(position: Index) -> Element {
        get {
            return dispatchQueue.sync { return realArray[position] }
        }
        set(newValue) {
            dispatchQueue.sync { realArray[position] = newValue }
        }
    }
}

extension SynchronizedArray: RangeReplaceableCollection {
    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, Element == C.Element, SynchronizedArray<Element>.Index == R.Bound {
        realArray.replaceSubrange(subrange, with: newElements)
    }
}
