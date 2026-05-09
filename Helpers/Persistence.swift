import Foundation

enum Persistence {
    private static let storage = UserDefaults.standard

    static func save<T: Encodable>(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            storage.set(data, forKey: key)
        } catch {
            print("Persistence save failed for \(key): \(error)")
        }
    }

    static func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = storage.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Persistence load failed for \(key): \(error)")
            return nil
        }
    }

    static func clear(_ key: String) {
        storage.removeObject(forKey: key)
    }
}

enum PersistenceKeys {
    static let goals = "snitch.goals"
    static let posts = "snitch.posts"
    static let groups = "snitch.groups"
    static let activeGroupId = "snitch.activeGroupId"
}
