import Foundation
#if os(macOS)
    import PostboxMac
#else
    import Postbox
#endif

public extension Peer {
    public var displayTitle: String {
        switch self {
            case let user as TelegramUser:
                return user.name
            case let group as TelegramGroup:
                return group.title
            case let channel as TelegramChannel:
                return channel.title
            default:
                return ""
        }
    }
    
    public var compactDisplayTitle: String {
        switch self {
            case let user as TelegramUser:
                if let firstName = user.firstName {
                    return firstName
                } else if let lastName = user.lastName {
                    return lastName
                } else {
                    return ""
                }
            case let group as TelegramGroup:
                return group.title
            case let channel as TelegramChannel:
                return channel.title
            default:
                return ""
        }
    }
    
    public var displayLetters: [String] {
        switch self {
            case let user as TelegramUser:
                if let firstName = user.firstName, let lastName = user.lastName, !firstName.isEmpty && !lastName.isEmpty {
                    return [firstName.substring(to: firstName.index(after: firstName.startIndex)).uppercased(), lastName.substring(to: lastName.index(after: lastName.startIndex)).uppercased()]
                } else if let firstName = user.firstName, !firstName.isEmpty {
                    return [firstName.substring(to: firstName.index(after: firstName.startIndex)).uppercased()]
                } else if let lastName = user.lastName, !lastName.isEmpty {
                    return [lastName.substring(to: lastName.index(after: lastName.startIndex)).uppercased()]
                }
                
                return []
            case let group as TelegramGroup:
                if group.title.startIndex != group.title.endIndex {
                    return [group.title.substring(to: group.title.index(after: group.title.startIndex)).uppercased()]
                } else {
                    return []
                }
            case let channel as TelegramChannel:
                if channel.title.startIndex != channel.title.endIndex {
                    return [channel.title.substring(to: channel.title.index(after: channel.title.startIndex)).uppercased()]
                } else {
                    return []
                }
            default:
                return []
        }
    }
}

public extension PeerId {
    public var isGroupOrChannel: Bool {
        switch self.namespace {
            case Namespaces.Peer.CloudGroup, Namespaces.Peer.CloudChannel:
                return true
            default:
                return false
        }
    }
}

public func peerDisplayTitles(_ peerIds: [PeerId], _ dict: SimpleDictionary<PeerId, Peer>) -> String {
    var peers: [Peer] = []
    for id in peerIds {
        if let peer = dict[id] {
            peers.append(peer)
        }
    }
    return peerDisplayTitles(peers)
}

public func peerDisplayTitles(_ peers: [Peer]) -> String {
    if peers.count == 0 {
        return ""
    } else {
        var string = ""
        var first = true
        for peer in peers {
            if first {
                first = false
            } else {
                string.append(", ")
            }
            string.append(peer.displayTitle)
        }
        return string
    }
}
