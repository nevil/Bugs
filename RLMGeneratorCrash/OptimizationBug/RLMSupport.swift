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

public final class RLMGenerator: GeneratorType {
    private let generatorBase: NSFastGenerator

    internal init(collection: RLMCollection) {
        generatorBase = NSFastGenerator(collection)
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
