import AVFoundation

@MainActor
final class SurpriseSound {
    private var player: AVAudioPlayer?

    func play() {
        guard let url = Bundle.main.url(forResource: "surprise-drumroll", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.65
            player?.play()
        } catch {
            // Audio is optional; the reveal continues if playback is unavailable.
        }
    }

    func stop() {
        player?.stop()
        player = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
