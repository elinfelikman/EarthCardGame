import Foundation
import AVFoundation

final class SoundManager {
    static let shared = SoundManager()

    private var bgmPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?

    private init() {}

    // Play background music, loops indefinitely
    func playBackgroundMusic(named name: String = "background_music") {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Background music file not found: \(name).mp3")
            return
        }
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1
            bgmPlayer?.prepareToPlay()
            bgmPlayer?.play()
        } catch {
            print("Failed to play background music: \(error)")
        }
    }

    // Pause background music
    func pauseBackgroundMusic() {
        bgmPlayer?.pause()
    }

    // Resume background music
    func resumeBackgroundMusic() {
        bgmPlayer?.play()
    }

    // Stop background music and release player
    func stopBackgroundMusic() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }

    // Play a short sound effect by file name (without extension)
    func playEffect(named name: String = "effect") {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Sound effect file not found: \(name).mp3")
            return
        }
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.prepareToPlay()
            sfxPlayer?.play()
        } catch {
            print("Failed to play sound effect: \(error)")
        }
    }
}
