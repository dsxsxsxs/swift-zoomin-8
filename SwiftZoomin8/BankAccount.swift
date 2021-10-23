import Foundation

actor BankAccount {
    private var balance: Int = 0
    func deposit(amount: Int)  -> Int {
        balance += amount
        return balance
    }
}

func bankAccountMain() {
    let account = BankAccount()
    Task {
        print(await account.deposit(amount: 1000))
    }

    Task {
        print(await account.deposit(amount: 1000))
    }

}
