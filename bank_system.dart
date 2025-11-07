abstract class BankAccount {
  // Private fields (Encapsulation)
  String _accountNumber;
  String _holderName;
  double _balance;

  // Constructor
  BankAccount(this._accountNumber, this._holderName, this._balance);

  // Getters
  String get accountNumber => _accountNumber;
  String get holderName => _holderName;
  double get balance => _balance;

  // Setter for name
  set holderName(String name) {
    if (name.isNotEmpty) {
      _holderName = name;
    } else {
      print("Name cannot be empty!");
    }
  }

  // Abstract methods (Abstraction)
  void deposit(double amount);
  void withdraw(double amount);

  // Display account info
  void displayInfo() {
    print("Account No: $_accountNumber | Name: $_holderName | Balance: \$$_balance");
  }

  // Protected method to update balance (for subclasses)
  void updateBalance(double newBalance) {
    _balance = newBalance;
  }
}


abstract class InterestBearing {
  double calculateInterest();
  void applyInterest();
}


class SavingsAccount extends BankAccount implements InterestBearing {
  int withdrawalCount = 0;

  SavingsAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      updateBalance(balance + amount);
      print("Deposited \$${amount} to Savings Account. New Balance: \$${balance}");
    } else {
      print("Deposit amount must be positive!");
    }
  }

  @override
  void withdraw(double amount) {
    if (withdrawalCount >= 3) {
      print("Withdrawal limit reached (3 times per month).");
      return;
    }

    if (balance - amount < 500) {
      print("Cannot withdraw. Minimum balance of \$500 required.");
      return;
    }

    updateBalance(balance - amount);
    withdrawalCount++;
    print("Withdrew \$${amount} from Savings Account. New Balance: \$${balance}");
  }

  @override
  double calculateInterest() {
    return balance * 0.02; // 2%
  }

  @override
  void applyInterest() {
    double interest = calculateInterest();
    updateBalance(balance + interest);
    print("Interest \$${interest} added. New Balance: \$${balance}");
  }
}

