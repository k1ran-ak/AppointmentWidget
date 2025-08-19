//
//  EventModel.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 07/07/25.
//
import Foundation

public struct EventModel: Codable {
    
    public var id: String
    public var calendar: String
    public var merchant: String
    public var brand: EventBrand
    public var type: EventType? = .event
    
    public var provider: [String]
    public var service: [String]
    public var consumer: [String]
    public var resource: [String]
    
    public var startDateTime: String?
    public var endDateTime: String?
    
    public var zuluStartDate: Date?
    public var zuluEndDate: Date?
    
    public var startTime: Double // milliseconds value for start and end time
    public var endTime: Double? // milliseconds value for start and end time
    public var maxSeats: Int
    public var cost: Double = 0
    public var isExternal: Bool = false
    public var isDeleted: Bool = false
    public var rRule: String?
    public var paymentStatus: String?
    public var label: String?
    public var bookingId: String?     // for user reference
    public var source: String?
    public var parentId: String?
    public var title: String? = ""
    public var isAllDay: Bool?
    
    public var location: EventLocation?
    public let metaData: EventMeta?
    public var timezone: String?
    
    public var notes: String?
    public var createdBy: String? // The user who created the event
    public var createdTime: Double?
    public var updatedTime: Double?
    
    public var dayCount: Int?
    public var totalDaysCount: Int?
    
    public var isSlotCheck: Bool?
    public var slotParams: SlotParam?
    public var videoIntegration: VideoMeetType?
    public var exceptionDates: [Double]?
    public var eventColor: String?
    
}

public enum EventBrand: String, Codable {
    case SetMore = "110003eb-76c1-4b81-a96a-4cdf91bf70fb"
}

public enum EventType: String, Codable, CaseIterable {
    case appointment = "APPOINTMENT"
    case event = "EVENT"
    case groupe = "GROUP"
    case offhours = "OFFHOURS"
    case session = "SESSION"
    case reminder = "REMINDER"
    
    /// User-friendly name for the event type
    public var eventTypeName: String? {
        switch self {
        case .appointment:
            return "service"
        case .event:
            return "event"
        case .session:
            return "class"
        case .groupe, .offhours, .reminder:
            return nil
        }
    }
}

public struct EventLocation: Codable {
    
    public var videoMeeting: String? // To support OLD Payload
    public private(set) var videoType: [VideoMeeting]?
    public private(set) var type: [LocationType]?
    public var customLocation: String?
    public private(set) var address: [Address]?
    
    init() {
        self.videoMeeting = nil
        self.videoType = nil
        self.type = nil
        self.customLocation = nil
        self.address = nil
    }
    
    func setVideoType(_ videoType: [VideoMeeting]?) -> EventLocation {
        var eventLocation = self
        eventLocation.videoType = videoType
        return eventLocation
    }
    
   func setType(_ type: [LocationType]?) -> EventLocation {
        var eventLocation = self
        eventLocation.type = type
        return eventLocation
    }
}

public enum LocationType: String, Codable, CaseIterable {
    case videoMeet = "videoType"
    case geoLocation = "geo" /// need to verify with geo location response
    case customLocation = "customLocation"
    case address = "address"
}

public struct VideoMeeting: Codable, Equatable {
    
    public var referrerType: ReferrerTypes?
    public var link: URL?
    public var id: ID?
    public var type: VideoMeetType
    public var isDefault: Bool?
}

public enum ReferrerTypes: String, Codable {
    case PROVIDER
    case CONSUMER
}

public enum VideoMeetType: Equatable, Codable, Hashable {
    
    case teleport
    case googleMeet
    case zoom
    case custom(String)
    
    var title: String {
        switch self {
        case .teleport: return "Teleport"
        case .googleMeet: return "Google Meet"
        case .zoom: return "Zoom"
        case .custom(let value): return value
        }
    }
}

public enum ID: Codable, Equatable {
    
    case integer(Int)
    case string(String)
}

public struct Address: Codable, Equatable {
    
    public var place_id: String?
    public var addressLine1, addressLine2: String
    public var city, state: String
    public var country, zip: String
    public var coordinates: Coordinates?
    
}

public struct Coordinates: Codable, Equatable {
    
    public var latitude, longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct EventMeta: Codable {
    
    public var attendees: [GoogleContact]?
    var eventId: String?
    var hangoutLink: URL?
    var iCalUId: String?
}

public struct SlotParam: Codable {
    
    public var isWorkingHours: Bool
    public var isDoubleBooking: Bool
    
    public init(isWorkingHours: Bool, isDoubleBooking: Bool) {
        self.isWorkingHours = isWorkingHours
        self.isDoubleBooking = isDoubleBooking
    }
}

public struct GoogleContact: Codable {
    
    public var name: String?
    public var email: String
    public var isOrganizer: Bool? = false
    public var isSelf: Bool? = false
    var responseStatus: ResponseStatus?
    
    enum CodingKeys: String, CodingKey {
        case isSelf = "self"
        case isOrganizer = "organizer"
        case email, responseStatus
        case name = "displayName"
    }
}

enum ResponseStatus: String, Codable, Equatable {
    case accepted
    case pending = "needsAction"
    case declined
    case tentative
}
