import AppIntents
import EventKit

struct ReminderListEntity: AppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Reminder List"
    static let defaultQuery = ReminderListQuery()

    var id: String
    var name: String
    var displayRepresentation: DisplayRepresentation { DisplayRepresentation(title: "\(name)") }
}

struct ReminderListQuery: EntityStringQuery {
    func entities(for identifiers: [String]) async throws -> [ReminderListEntity] {
        try await lists().filter { identifiers.contains($0.id) }
    }

    func entities(matching string: String) async throws -> [ReminderListEntity] {
        try await lists().filter { $0.name.localizedCaseInsensitiveContains(string) }
    }

    func suggestedEntities() async throws -> [ReminderListEntity] {
        try await lists()
    }

    private func lists() async throws -> [ReminderListEntity] {
        let store = try await RemindersAccess.authorizedStore()
        return store.calendars(for: .reminder).map { ReminderListEntity(id: $0.calendarIdentifier, name: $0.title) }
    }
}

enum RemindersAccess {
    static func authorizedStore() async throws -> EKEventStore {
        let store = EKEventStore()
        if EKEventStore.authorizationStatus(for: .reminder) != .fullAccess {
            guard try await store.requestFullAccessToReminders() else { throw RemindersError.denied }
        }
        return store
    }
}

enum RemindersError: LocalizedError {
    case denied
    case listNotFound
    case noDefaultList

    var errorDescription: String? {
        switch self {
        case .denied: "Reminders access is denied. Enable it in Settings."
        case .listNotFound: "That reminder list no longer exists."
        case .noDefaultList: "No default reminder list is set."
        }
    }
}

struct CreateReminderIntent: AppIntent {
    static let title: LocalizedStringResource = "Create Reminder"
    static let description = IntentDescription("Adds a reminder to a Reminders list.")

    @Parameter(title: "Title") var reminderTitle: String
    @Parameter(title: "Due Date") var dueDate: Date?
    @Parameter(title: "List") var list: ReminderListEntity?

    static var parameterSummary: some ParameterSummary {
        Summary("Create reminder \(\.$reminderTitle) due \(\.$dueDate) in \(\.$list)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let store = try await RemindersAccess.authorizedStore()
        let calendar: EKCalendar
        if let list {
            guard let found = store.calendar(withIdentifier: list.id) else { throw RemindersError.listNotFound }
            calendar = found
        } else {
            guard let fallback = store.defaultCalendarForNewReminders() else { throw RemindersError.noDefaultList }
            calendar = fallback
        }

        let reminder = EKReminder(eventStore: store)
        reminder.title = reminderTitle
        reminder.calendar = calendar
        if let dueDate {
            reminder.dueDateComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute], from: dueDate)
            reminder.addAlarm(EKAlarm(absoluteDate: dueDate))
        }
        try store.save(reminder, commit: true)

        return .result(value: reminderTitle, dialog: "Added \(reminderTitle) to \(calendar.title).")
    }
}
