import UIKit
import Combine

final class UserViewController: UIViewController {

    private let iconImageView: UIImageView = .init()
    private let nameLabel: UILabel = .init()

    private let userViewState: UserViewState
    private var cancellables: Set<AnyCancellable> = []
    init(id: User.ID) {
        self.userViewState = .init(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // レイアウト
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.cornerRadius = 40
        iconImageView.layer.borderWidth = 4
        iconImageView.layer.borderColor = UIColor.systemGray3.cgColor
        iconImageView.clipsToBounds = true
        view.addSubview(iconImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
        ])

        setupBindings()
    }

    private func setupBindings() {
        Task {
            await userViewState.$user
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] in
                    self?.nameLabel.text = $0?.name
                })
                .store(in: &cancellables)

            await userViewState.$iconImage
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] in
                    self?.iconImageView.image = $0
                })
                .store(in: &cancellables)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            await userViewState.loadUser()
        }
        // User の JSON の取得
        
    }
}

extension Published.Publisher: @unchecked Sendable {}
