//
//  RealmModels.swift
//  OptimizationBug
//
//  Created by Anders Hasselqvist on 6/14/16.
//


class TitleInfoRLM: RLMObject {
    dynamic var titleCode: String
    dynamic var titleName: String
    dynamic var episodes = RLMArray(objectClassName: EpisodeInfoRLM.className())

    init(titleCode: String, titleName: String, updateDate: NSDate = NSDate(timeIntervalSince1970: 0)) {
        self.titleCode = titleCode
        self.titleName = titleName
        super.init()
    }

    @available(*, unavailable, message="This init is only used by Realm for temporary objects")
    private override init() {
        titleCode = ""
        titleName = ""
        super.init()
    }

    override class func primaryKey() -> String {
        return "titleCode"
    }

    override class func requiredProperties() -> [String] {
        return ["titleCode", "titleName", "updateDate", "episodes"]
    }
}

// Episode Information
class EpisodeInfoRLM: RLMObject {
    dynamic var episodeCode: String
    dynamic var episodeName: String

    dynamic var titleInfo: RLMLinkingObjects! // Link back to TitleInfoRLM

    init(episodeCode: String, episodeName: String) {
        self.episodeCode = episodeCode
        self.episodeName = episodeName

        super.init()
    }

    @available(*, unavailable, message="This init is only used by Realm for temporary objects")
    private override init() {
        episodeCode = ""
        episodeName = ""
        super.init()
    }

    override class func linkingObjectsProperties() -> [String : RLMPropertyDescriptor] {
        let prop = RLMPropertyDescriptor(withClass: TitleInfoRLM.self, propertyName: "episodes")
        return ["titleInfo" : prop]
    }

    override class func requiredProperties() -> [String] {
        return ["episodeCode", "episodeName"]
    }

    override class func primaryKey() -> String {
        return "episodeCode"
    }
}

class CombinedInfo {
    let titleCode: String
    let titleName: String
    let episodeCode: String
    let episodeName: String

    init(episode: EpisodeInfoRLM) {
        self.titleCode = (episode.titleInfo[0] as! TitleInfoRLM).titleCode
        self.titleName = (episode.titleInfo[0] as! TitleInfoRLM).titleName
        self.episodeCode = episode.episodeCode
        self.episodeName = episode.episodeCode
    }
}

class DB {

    static var sharedInstance: DB {
        struct Static {
            static let instance = DB()
        }

        return Static.instance
    }

    private init() {
        let episode = EpisodeInfoRLM(episodeCode: "E1", episodeName: "Episode 1")
        let title = TitleInfoRLM(titleCode: "T1", titleName: "Great burgers of the world")
        title.episodes.addObject(episode)

        let config = RLMRealmConfiguration.defaultConfiguration()
        config.inMemoryIdentifier = "SampleDB"
        RLMRealmConfiguration.setDefaultConfiguration(config)

        let realm = RLMRealm.defaultRealm()
        do {
            try realm.transactionWithBlock {
                realm.addOrUpdateObject(title)
            }
        } catch {
            print("Error \(error)")
        }
    }

    internal var allItems: [CombinedInfo]? {
        let items: [CombinedInfo] = EpisodeInfoRLM.allObjects().flatMap({
            if let e = $0 as? EpisodeInfoRLM {
                return CombinedInfo(episode: e)
            } else {
                return nil
            }
        })

        return items.isEmpty ? nil : items
    }
}

