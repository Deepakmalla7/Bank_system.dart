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


class CheckingAccount extends BankAccount {
  CheckingAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      updateBalance(balance + amount);
      print("Deposited \$${amount} to Checking Account. New Balance: \$${balance}");
    } else {
      print("Deposit amount must be positive!");
    }
  }

  @override
  void withdraw(double amount) {
    if (amount > 0) {
      updateBalance(balance - amount);
      if (balance < 0) {
        updateBalance(balance - 35); // overdraft fee
        print("Overdraft fee of \$35 applied!");
      }
      print("Withdrew \$${amount} from Checking Account. New Balance: \$${balance}");
    } else {
      print("Invalid withdrawal amount!");
    }
  }
}


class PremiumAccount extends BankAccount implements InterestBearing {
  PremiumAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      updateBalance(balance + amount);
      print("Deposited \$${amount} to Premium Account. New Balance: \$${balance}");
    } else {
      print("Deposit amount must be positive!");
    }
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 10000) {
      print("Cannot withdraw. Must maintain \$10,000 minimum balance.");
    } else {
      updateBalance(balance - amount);
      print("Withdrew \$${amount} from Premium Account. New Balance: \$${balance}");
    }
  }

  @override
  double calculateInterest() {
    return balance * 0.05; // 5%
  }

  @override
  void applyInterest() {
    double interest = calculateInterest();
    updateBalance(balance + interest);
    print("Interest \$${interest} added. New Balance: \$${balance}");
  }
}


class Bank {
  List<BankAccount> accounts = [];

  // Add account
  void addAccount(BankAccount account) {
    accounts.add(account);
  }

  // Find account by number
  BankAccount? findAccount(String accNo) {
    for (var acc in accounts) {
      if (acc.accountNumber == accNo) {
        return acc;
      }
    }
    return null;
  }

  // Transfer money
  void transfer(String fromNo, String toNo, double amount) {
    var from = findAccount(fromNo);
    var to = findAccount(toNo);

    if (from == null || to == null) {
      print("One of the accounts was not found!");
      return;
    }

    from.withdraw(amount);
    to.deposit(amount);
    print("Transferred \$${amount} from $fromNo to $toNo.");
  }

  // Show all accounts
  void showAllAccounts() {
    print("\n--- Bank Report ---");
    for (var acc in accounts) {
      acc.displayInfo();
    }
    print("-------------------\n");
  }
}


void main() {
  // Create bank
  Bank bank = Bank();

  // Create accounts
  SavingsAccount s1 = SavingsAccount("S001", "Alice", 1000);
  CheckingAccount c1 = CheckingAccount("C001", "Bob", 300);
  PremiumAccount p1 = PremiumAccount("P001", "Charlie", 15000);

  // Add to bank
  bank.addAccount(s1);
  bank.addAccount(c1);
  bank.addAccount(p1);

  // Test operations
  s1.withdraw(200);
  s1.deposit(100);
  s1.applyInterest();

  c1.withdraw(400); // causes overdraft
  c1.deposit(200);

  p1.withdraw(4000);  
  p1.applyInterest();

  // Transfer between accounts
  bank.transfer("S001", "C001", 100);

  // Show all accounts
  bank.showAllAccounts();
}
