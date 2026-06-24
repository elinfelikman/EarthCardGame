import UIKit

final class GameViewController: UIViewController {
    // Outlets
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var leftNameLabel: UILabel!
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var rightNameLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    @IBOutlet weak var leftCardImageView: UIImageView!
    @IBOutlet weak var rightCardImageView: UIImageView!

    // Inputs
    var userName: String = "Player"
    var isUserEastSide: Bool = false

    // Model
    private let model = GameModel()

    // Timer control
    private var gameTimer: Timer?
    private var isPaused = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNames()
        updateUI(with: model.state)

        // Observe lifecycle
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)

        model.onStateChange = { [weak self] state in
            DispatchQueue.main.async { self?.updateUI(with: state) }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SoundManager.shared.playBackgroundMusic()
        startGame()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer?.invalidate()
        gameTimer = nil
    }

    @objc private func appDidBecomeActive() {
        isPaused = false
        SoundManager.shared.resumeBackgroundMusic()
    }

    @objc private func appWillResignActive() {
        isPaused = true
        SoundManager.shared.pauseBackgroundMusic()
    }

    private func configureNames() {
        if isUserEastSide {
            leftNameLabel.text = "PC"
            rightNameLabel.text = userName
        } else {
            leftNameLabel.text = userName
            rightNameLabel.text = "PC"
        }
    }

    private func updateUI(with state: GameModel.State) {
        let leftScore = isUserEastSide ? state.pcScore : state.userScore
        let rightScore = isUserEastSide ? state.userScore : state.pcScore
        leftScoreLabel.text = "\(leftScore)"
        rightScoreLabel.text = "\(rightScore)"
        roundLabel.text = "Round \(min(state.round, model.maxRounds))/\(model.maxRounds)"

        if state.isFlipped {
            let leftCard = isUserEastSide ? state.pcCard : state.userCard
            let rightCard = isUserEastSide ? state.userCard : state.pcCard
            leftCardImageView.image = leftCard.flatMap { UIImage(named: $0.imageName) }
            rightCardImageView.image = rightCard.flatMap { UIImage(named: $0.imageName) }
        } else {
            leftCardImageView.image = UIImage(systemName: "questionmark")
            rightCardImageView.image = UIImage(systemName: "questionmark")
        }

        if state.isGameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                SoundManager.shared.pauseBackgroundMusic()
                SoundManager.shared.playWin()
                self.navigateToSummary(userScore: state.userScore, pcScore: state.pcScore)
            }
        }
    }

    private func startGame() {
        model.reset()
        scheduleTimer()
    }

    private func scheduleTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            guard !self.isPaused else { return }
            self.performRound()
        }
    }

    private func performRound() {
        SoundManager.shared.playFlip()
        model.drawAndScore()
        // flip back after 3 seconds, then model advances round/end
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.model.flipBackAndAdvance()
            if let state = self?.model.state, state.isGameOver {
                self?.gameTimer?.invalidate()
                self?.gameTimer = nil
            }
        }
    }

    private func navigateToSummary(userScore: Int, pcScore: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let summary = storyboard.instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController else { return }
        summary.userName = userName
        summary.userScore = userScore
        summary.pcScore = pcScore
        navigationController?.pushViewController(summary, animated: true)
    }
}
