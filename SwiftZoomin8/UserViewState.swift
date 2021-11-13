import Combine
import Foundation

import class UIKit.UIImage

@MainActor
final class UserViewState: ObservableObject {
    let id: User.ID
    
    @Published private(set) var user: User?
    @Published private(set) var iconImage: UIImage?
    
    init(id: User.ID) {
        self.id = id
    }

    func loadUser() async {
        do {
            let url: URL = .init(string: "https://koherent.org/fake-service/api/user?id=\(id)")!

            let userData = try await downloadData(from: url)
            let user: User = try JSONDecoder().decode(User.self, from: userData)

            self.user = user

            let iconData = try await downloadData(from: user.iconURL)
            // Data を UIImage に変換
            guard let iconImage: UIImage = .init(data: iconData) else {
                // エラーハンドリング
                print("The icon image at \(user.iconURL) has an illegal format.")
                return
            }

            self.iconImage = iconImage
        } catch {
            // エラーハンドリング
            print(error)
        }
    }
}
