import Foundation

// typed errors so callers can react properly instead of guessing what went wrong
enum PersistenceError: Error {
    case encodingFailed(key: String, underlying: Error)
    case decodingFailed(key: String, underlying: Error)
}

enum Persistence {
    private static let storage = UserDefaults.standard

    // throws when the value cannot be encoded
    // callers can use try? if they want to keep silent fallback behaviour
    static func save<T: Encodable>(_ value: T, forKey key: String) throws {
        do {
            let data = try JSONEncoder().encode(value)
            storage.set(data, forKey: key)
        } catch {
            throw PersistenceError.encodingFailed(key: key, underlying: error)
        }
    }

    // returns nil when nothing is stored or the stored data cannot be read
    // decode failures are logged so we know when the on-disk shape has drifted
    static func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = storage.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Persistence decode failed for \(key): \(PersistenceError.decodingFailed(key: key, underlying: error))")
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
    static let users = "snitch.users"
}
