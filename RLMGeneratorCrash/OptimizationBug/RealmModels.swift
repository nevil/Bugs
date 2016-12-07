//
//  RealmModels.swift
//  OptimizationBug
//
//  Created by Anders Hasselqvist on 6/14/16.
//


class TitleInfoRLM: RLMObject {
    dynamic var name: String

    init(name: String) {
        self.name = name
        super.init()
    }

    @available(*, unavailable, message: "This init is only used by Realm for temporary objects")
    fileprivate override init() {
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

class CombinedInfo {
    let titleName: String

    init(title: TitleInfoRLM) {
        self.titleName = title.name
    }
}

class DB {

    static var sharedInstance: DB {
        struct Static {
            static let instance = DB()
        }

        return Static.instance
    }

    fileprivate init() {
        let title = TitleInfoRLM(name: "Great burgers of the world")

        let config = RLMRealmConfiguration.default()
        config.inMemoryIdentifier = "KeepItInMem"
        RLMRealmConfiguration.setDefault(config)

        let realm = RLMRealm.default()
        do {
            try realm.transaction {
                realm.addOrUpdate(title)
            }
        } catch {
            print("Error \(error)")
        }
    }

    internal var allItems: [CombinedInfo]? {
        let items: [CombinedInfo] = TitleInfoRLM.allObjects().flatMap({
            if let t = $0 as? TitleInfoRLM {
                return CombinedInfo(title: t)
            } else {
                return nil
            }
        })

        return items.isEmpty ? nil : items
    }
}

