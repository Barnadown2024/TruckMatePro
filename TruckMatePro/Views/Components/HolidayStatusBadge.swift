import SwiftUI

struct HolidayStatusBadge: View {
    let status: HolidayRequestStatus
    
    var color: Color {
        switch status {
        case .pending: return .yellow
        case .approved: return .green
        case .rejected: return .red
        }
    }
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}
