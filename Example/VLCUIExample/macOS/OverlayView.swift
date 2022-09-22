import SwiftUI
import VLCUI

struct OverlayView: View {

    @ObservedObject
    var viewModel: ContentViewModel
    @State
    var isScrubbing: Bool = false
    @State
    var currentPosition: Float = 0

    var body: some View {
        HStack(spacing: 20) {

            Button {
                viewModel.eventSubject.send(.jumpBackward(15))
            } label: {
                Image(systemName: "gobackward.15")
                    .font(.system(size: 28, weight: .regular, design: .default))
            }
            .buttonStyle(.plain)

            Button {
                if viewModel.playerState == .playing {
                    viewModel.eventSubject.send(.pause)
                } else {
                    viewModel.eventSubject.send(.play)
                }
            } label: {
                Group {
                    if viewModel.playerState == .playing {
                        Image(systemName: "pause.circle.fill")
                    } else if viewModel.playerState == .buffering {
                        ProgressView()
                    } else {
                        Image(systemName: "play.circle.fill")
                    }
                }
                .font(.system(size: 28, weight: .heavy, design: .default))
                .frame(maxWidth: 30)
            }
            .buttonStyle(.plain)

            Button {
                viewModel.eventSubject.send(.jumpForward(15))
            } label: {
                Image(systemName: "goforward.15")
                    .font(.system(size: 28, weight: .regular, design: .default))
            }
            .buttonStyle(.plain)

            HStack(spacing: 5) {
                Text(viewModel.positiveTimeLabel)
                    .frame(width: 50)

                Slider(
                    value: $currentPosition,
                    in: 0 ... Float(1.0)
                ) { isEditing in
                    isScrubbing = isEditing
                }

                Text(viewModel.negativeTimeLabel)
                    .frame(width: 50)
            }
        }
        .onChange(of: isScrubbing) { isScrubbing in
            guard !isScrubbing else { return }
            self.viewModel.eventSubject.send(.setTime(.ticks(viewModel.totalTicks * Int32(currentPosition * 100) / 100)))
        }
        .onChange(of: viewModel.position) { newValue in
            guard !isScrubbing else { return }
            self.currentPosition = newValue
        }
    }
}