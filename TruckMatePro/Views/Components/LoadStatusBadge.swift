import SwiftUI

struct LoadStatusBadge: View {
    let status: LoadStatus
    
    var color: Color {
        switch status {
        case .pending: return .yellow
        case .inProgress: return .blue
        case .completed: return .green
        case .cancelled: return .red
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
