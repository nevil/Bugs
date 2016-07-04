//
//  main.swift
//  AutoRelease
//
//  Created by Anders Hasselqvist on 7/4/16.
//  Copyright © 2016 Anders Hasselqvist. All rights reserved.
//

class TitleInfoRLM: RLMObject {
    dynamic var name: String

    init(name: String) {
        self.name = name
        super.init()
    }

    @available(*, unavailable, message="This init is only used by Realm for temporary objects")
    private override init() {
        name = ""
        super.init()
    }

    override class func primaryKey() -> String {
        return "name"
    }

    override class func requiredProperties() -> [String] {
        return ["name"]
    }
}


let config = RLMRealmConfiguration.defaultConfiguration()
config.inMemoryIdentifier = "KeepItInMem"
RLMRealmConfiguration.setDefaultConfiguration(config)

autoreleasepool {
    let title = TitleInfoRLM(name: "Great burgers of the world")

    let realm = RLMRealm.defaultRealm()
    do {
        try realm.transactionWithBlock {
            realm.addOrUpdateObject(title)
        }
    } catch {
        print("Error \(error)")
    }
    print("Count: \(TitleInfoRLM.allObjects().count)")
}

print("Count: \(TitleInfoRLM.allObjects().count)")

var name: String = "Not Expected"
if let t = TitleInfoRLM.allObjects().firstObject() as? TitleInfoRLM {
    name = t.name
}

print("Name: \(name)")

