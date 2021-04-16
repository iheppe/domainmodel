import Foundation

struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    init(amount: Int, currency: String) {
        self.currency = currency
        self.amount = amount

    }
    
    func convert(_ currType: String) -> Money {
        if (self.currency == currType) {
            return self
        }
        var newAmt = Double(self.amount)
        if (self.currency == "GBP") {
            newAmt *= 2
        } else if (self.currency == "CAN") {
            newAmt /= 1.25
        } else if (self.currency == "EUR") {
            newAmt /= 1.5
        }
        if (currType == "EUR") {
            newAmt *= 1.5
        } else if (currType == "GBP") {
            newAmt /= 2
            
        } else if (currType == "CAN") {
            newAmt *= 1.25
        }
        let roundedAmt = Int(round(newAmt))
        return Money(amount: roundedAmt, currency: currType)
    }
    
    func add(_ mun2: Money) -> Money{
        var curr = mun2.amount
        if (self.currency == mun2.currency) {
            curr += self.amount
        } else {
            let newMun = self.convert(mun2.currency)
            curr += newMun.amount
        }
        return Money(amount: curr, currency: mun2.currency)
    }
    
    func subtract(_ mun2: Money) -> Money {
        var curr: Int
        if (self.currency == mun2.currency) {
            curr = self.amount - mun2.amount
        } else {
            let newMun = self.convert(mun2.currency)
            curr = newMun.amount - mun2.amount
        }
        return Money(amount: curr, currency: mun2.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title: String
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    public func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
            case .Hourly(let wage):
                return Int(wage * Double(hours))
            case .Salary(let salary):
                return Int(salary)
        }
    }
    
    public func raise(byAmount: Double) {
        switch self.type{
        case .Hourly(let wage):
            self.type = JobType.Hourly(wage + byAmount)
        case.Salary(let salary):
            self.type = JobType.Salary(salary + UInt(byAmount))
        }
    }
    
    public func raise(byPercent: Double) {
        switch self.type{
        case .Hourly(let wage):
            self.type = JobType.Hourly(wage + (wage * byPercent))
        case.Salary(let salary):
            self.type = JobType.Salary(salary + UInt(Double(salary) * byPercent))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if age < 16 {
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if age < 16 {
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public func toString() -> String {
        var result = "[Person: firstName:" + firstName + " lastName:" + lastName + " age:" + String(age) + " job:"
        if job != nil {
            result += job!.title
        } else {
            result += "nil"
        }
        result += " spouse:"
        if spouse != nil {
            result += spouse!.firstName
        } else {
            result += "nil"
        }
        result += "]"
        return result
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init (spouse1: Person, spouse2: Person) {
        members = [Person]()
        if (spouse1.spouse == nil || spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
    
    public func haveChild(_ child: Person) -> Bool {
        if members[0].age < 21 && members[1].age < 21 {
            return false
        } else {
            members.append(child)
            return true
        }
    }
    
    public func householdIncome() -> Int {
        var result = 0
        for member in members {
            if member.job != nil {
                result += member.job!.calculateIncome(2000)
            }
        }
        return result
    }
}
