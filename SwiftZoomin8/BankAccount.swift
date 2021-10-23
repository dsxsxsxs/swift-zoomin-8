import Foundation

actor BankAccount {
    private var balance: Int = 0

    func getInterest(with rate: Double) -> Int {
        let interest = Double(balance) * rate
        return deposit(amount: Int(interest))
    }
    func deposit(amount: Int)  -> Int {
        balance += amount
        return balance
    }
}

func bankAccountMain() {
    let account = BankAccount()
    Task {
        print(await account.deposit(amount: 1000))
        print(await account.deposit(amount: 1000))
        print(await account.getInterest(with: 0.05))
    }

}
