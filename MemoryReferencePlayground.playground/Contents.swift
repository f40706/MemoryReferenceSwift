import UIKit

//在Swift中，Automatic Reference Counting(ARC)自動參考計數機制
//與宣告時，參考的Weak、Strong、Unowned有關
//如果宣告並無特別設定，基本上都是Strong
//並且設定時有限定，宣告必須是class類型，才能在前方加上weak與unowned

//non-optional與let 不可使用 weak
//optional 不可使用 unowned

print("--------------")
print("-----Test1----")
class Person {
    var name: String
    init(name: String) {
        self.name = name
        print("init1 \(name)")
    }

    deinit {
        print("deinit1 \(name)")
    }
}

class Car {
    var name: String
    var person: Person?
    init(name: String) {
        self.name = name
        print("init1 \(name)")
    }

    deinit {
        print("deinit1 \(name)")
    }
}

var john: Person? = Person(name: "john")
var car: Car? = Car(name: "Tesla")

car?.person = john

//第一種狀況
//Car的Person 並沒有使用weak
//john設為nil時，並無 deinit
//直到car設為nil時，才釋放john

//解決方法
//請看狀況二
print("----")
john = nil
car?.person
car = nil


print("--------------")
print("-----Test2----")
class Person2 {
    var name: String
    init(name: String) {
        self.name = name
        print("init2 \(name)")
    }

    deinit {
        print("deinit2 \(name)")
    }
}

class Car2 {
    var name: String
    weak var person: Person2?
    init(name: String) {
        self.name = name
        print("init2 \(name)")
    }

    deinit {
        print("deinit2 \(name)")
    }
}

var john2: Person2? = Person2(name: "john")
var car2: Car2? = Car2(name: "Tesla")

car2?.person = john2

//第二種狀況
//Car的Person2 使用weak
//john設為nil時，直接釋放 deinit
//因此car?.person 直接顯示nil
print("----")
john2 = nil
car2?.person
car2 = nil


print("--------------")
print("-----Test3----")
class Person3 {
    var name: String
    private var car: Car3?
    init(name: String) {
        self.name = name
        car = Car3(name: "Tesla", person: self)
        print("init3 \(name)")
    }

    deinit {
        print("deinit3 \(name)")
    }
}

class Car3 {
    var name: String
    unowned let person: Person3
    init(name: String, person: Person3) {
        self.name = name
        self.person = person
        print("init3 \(name)")
    }

    deinit {
        print("deinit3 \(name)")
    }
}

var john3: Person3! = Person3(name: "john")

//第三種狀況
//john生成的時候，直接生成Car

//----------------------
//如果Car內部的Person使用let
//john內部Car使用var
//當john == nil時，並不會釋放，導致記憶體洩漏

//----------------------
//如果Car內部的Person使用let
//john內部Car使用weak var
//初始化後，馬上Car就被釋放，完全無法使用

//----------------------
//此時在Car內部的Person改為unowned let
//john內部Car使用var
//john釋放時，Car就會釋放
//john建立新的，舊的也會先釋放

//備註：此處Person Car應該使用private，不該外曝
//像Person一樣的用法
//如果使用john.car = car等方法的話
//當john被釋放了，再去呼叫car.person會直接閃退

//這一步很關鍵，很多記憶體洩漏都是這樣導致的

print("--------")
john3 = nil
print("--------")
john3 = Person3(name: "john")
print("--------")
john3 = nil


//總結：
//預設宣告Strong，強行擁有，只要有一方沒有釋放，就會一直保留
//所以在釋放前，需要把所有依賴都先釋放掉，才能避免記憶體洩漏(memory leak)
//-----------------------
//宣告使用Weak，弱引用，只要(當下瞬間)，沒有任何人引用就會直接被釋放
//所以在內部宣告使用，因為宣告完後，沒有其他引用，宣告完就會直接被釋放
//可以這樣使用：內部宣告Weak，外部給予參考，外部參考釋放他跟的釋放
//-----------------------
//宣告使用unowned，不強行擁有，互相引用時，引用時如果為unowned，不會強行握住對方，不讓對方釋放
//因此使用時，應該注意使用unowned的那方，盡量不要外曝，否則程式碼一多，忘記或漏檢查，先前已經釋放了，再去呼叫他，就直接閃退了
