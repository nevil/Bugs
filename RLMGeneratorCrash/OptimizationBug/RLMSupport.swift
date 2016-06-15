////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

final public class MyFastGenerator : GeneratorType {
    var enumerable: NSFastEnumeration
    var state: [NSFastEnumerationState]
    var n: Int
    var count: Int

    /// Size of ObjectsBuffer, in ids.
    var STACK_BUF_SIZE: Int { return 4 }

    /// Must have enough space for STACK_BUF_SIZE object references.
    struct ObjectsBuffer {
        var buf = (COpaquePointer(), COpaquePointer(),
                   COpaquePointer(), COpaquePointer())
    }
    var objects: [ObjectsBuffer]

    @inline(never)
    public func next() -> AnyObject? {
        print("MyFastGenerator next")
        if n == count {
            // FIXME: Is this check necessary before refresh()?
            if count == 0 { return .None }
            refresh()
            if count == 0 { return .None }
        }
        let next : AnyObject = state[0].itemsPtr[n]!
        n += 1
        return next
    }

    @inline(never)
    func refresh() {
        print("MyFastGenerator refresh")
        n = 0
        count = enumerable.countByEnumeratingWithState(
            state._baseAddressIfContiguous,
            objects: AutoreleasingUnsafeMutablePointer(
                objects._baseAddressIfContiguous),
            count: STACK_BUF_SIZE)
    }

    @inline(never)
    public init(_ enumerable: NSFastEnumeration) {
        print("MyFastGenerator init")
        self.enumerable = enumerable
        self.state = [ NSFastEnumerationState(
            state: 0, itemsPtr: nil,
            mutationsPtr: _fastEnumerationStorageMutationsPtr,
            extra: (0, 0, 0, 0, 0)) ]
        self.objects = [ ObjectsBuffer() ]
        self.n = -1
        self.count = -1
    }

    deinit {
        print("MyFastGenerator deinit")
    }
}


public final class RLMGenerator: GeneratorType {
    private let generatorBase: MyFastGenerator

    internal init(collection: RLMCollection) {
        generatorBase = MyFastGenerator(collection)
    }

// Enable this property to fix the optimization issue
//    @inline(never)
    public func next() -> RLMObject? {
        return generatorBase.next() as! RLMObject?
    }
}

extension RLMResults: SequenceType {
    // Support Sequence-style enumeration
    public func generate() -> RLMGenerator {
        return RLMGenerator(collection: self)
    }
}
