import SwiftUI

struct PeekEyesView: View {
    enum Look {
        case left, right, down, outward
    }

    enum EyeShape {
        case round
        case rectangle
    }

    var width: CGFloat = 14
    var height: CGFloat = 14
    var shape: EyeShape = .round
    var eyeColor: Color = .white
    var pupilColor: Color = AppColours.ink
    var strokeColor: Color = AppColours.ink
    var strokeWidth: CGFloat = 1.5
    var look: Look = .outward

    var body: some View {
        HStack(spacing: width * 0.32) {
            eye(side: .left)
            eye(side: .right)
        }
    }

    private enum Side { case left, right }

    private func eye(side: Side) -> some View {
        ZStack {
            // Eye shell
            Group {
                if shape == .round {
                    Circle()
                        .fill(eyeColor)
                        .overlay(Circle().stroke(strokeColor, lineWidth: strokeWidth))
                } else {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(eyeColor)
                        .overlay(RoundedRectangle(cornerRadius: 1).stroke(strokeColor, lineWidth: strokeWidth))
                }
            }

            // Pupil
            Group {
                if shape == .round {
                    Circle()
                        .fill(pupilColor)
                        .frame(width: min(width, height) * 0.42, height: min(width, height) * 0.42)
                } else {
                    Rectangle()
                        .fill(pupilColor)
                        .frame(width: width * 0.42, height: height * 0.42)
                }
            }
            .offset(pupilOffset(for: side))
        }
        .frame(width: width, height: height)
    }

    private func pupilOffset(for side: Side) -> CGSize {
        let dx: CGFloat
        let dy: CGFloat
        switch look {
        case .left:
            dx = -width * 0.18
            dy = 0
        case .right:
            dx = width * 0.18
            dy = 0
        case .down:
            dx = 0
            dy = height * 0.16
        case .outward:
            dx = side == .left ? -width * 0.18 : width * 0.18
            dy = 0
        }
        return CGSize(width: dx, height: dy)
    }
}
