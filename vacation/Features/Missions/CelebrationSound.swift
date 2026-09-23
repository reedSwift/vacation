import AVFoundation

@MainActor
final class CelebrationSound {
    private var player: AVAudioPlayer?

    func play() {
        guard let url = Bundle.main.url(forResource: "mission-celebration", withExtension: "wav") else { return }
        do {
            // Ambient audio respects Silent Mode and mixes with existing music.
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.6
            player?.play()
        } catch {
            // The visual celebration still works when audio is unavailable.
        }
    }

    func stop() {
        player?.stop()
        player = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
