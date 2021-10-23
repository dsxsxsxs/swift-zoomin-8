import Foundation

actor BankAccount {
    enum WithdrawError: Error {
        case insufficientBalance
    }
    private var balance: Int = 0

    func getInterest(with rate: Double) -> Int {
        deposit(amount: Int(Double(balance) * rate))
    }

    @discardableResult
    func deposit(amount: Int)  -> Int {
        precondition(amount >= 0)
        balance += amount
        return balance
    }

    @discardableResult
    func withdraw(amount: Int) throws -> Int {
        precondition(amount >= 0)
        guard balance >= amount else {
            throw WithdrawError.insufficientBalance
        }
        balance -= amount
        return balance
    }

    func transfer(amount: Int, to account: BankAccount) async throws {
        try withdraw(amount: amount)
        await account.deposit(amount: amount)
    }
}

func bankAccountMain() {
    let account = BankAccount()
    let account2 = BankAccount()
    Task {
        await account2.deposit(amount: 100)
        print(await account.deposit(amount: 1000))
        print(await account.deposit(amount: 1000))
        print(await account.getInterest(with: 0.05))
        print(try await account.transfer(amount: 200, to: account2))
    }

}
