import Foundation

actor BankAccount {
    enum BankAccountError: Error {
        case insufficientBalance
    }
    private var balance: Int = 0

    func getInterest(with rate: Double) -> Int {
        deposit(amount: Int(Double(balance) * rate))
    }
    func deposit(amount: Int)  -> Int {
        balance += amount
        return balance
    }

    func withdraw(amount: Int) throws -> Int {
        if balance - amount < 0 {
            throw BankAccountError.insufficientBalance
        }
        balance -= amount
        return balance
    }

    func transfer(amount: Int, to account: BankAccount) async throws -> Int {
        _ = try withdraw(amount: amount)
        return await account.deposit(amount: amount)
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
