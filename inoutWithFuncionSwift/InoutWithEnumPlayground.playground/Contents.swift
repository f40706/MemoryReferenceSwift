import SwiftUI

struct Student {
    var name: String
    let exam: Bool
}

struct Teacher {
    var name: String
    let isWork: Bool
}

enum Person {
    case student(Student)
    case teacher(Teacher)
}

//狀況1
class School: ObservableObject {
    var people: [Person] = []
    func getPeople() {
        people = [
            Person.student(Student(name: "john", exam: false)),
            Person.teacher(Teacher(name: "Alisa", isWork: true))

        ]
    }

    //尋找資料OK
    func printData() -> Bool {
        if people.count != 2 {
            return false
        }
        switch(people[0]) {
        case .student(let student):
            print(student)
            break
        case .teacher(let teacher):
            print(teacher)
            break
        }
        switch(people[1]) {
        case .student(let student):
            print(student)
            break
        case .teacher(let teacher):
            print(teacher)
            break
        }
        return true
    }

    func modifyStudentData() -> Bool {
        if people.count != 2 {
            return false
        }
        switch(people[0]) {
        case .student(var student):
            student.name = "123"
            print("student.name \(student.name), 123")
            break
        case .teacher(var teacher):
            teacher.name = "234"
            print("student.name \(teacher.name), 234")
            break
        }
        return true
    }
}

let school = School()
school.getPeople()
school.printData()

print("-------Modify-------")
school.modifyStudentData()
school.printData()
//此方法Enum雖然好用
//但此時會發現無法修改資料，只能讀取


print("------------------------------------------")
print("------------------------------------------")
//----------------------------------

class School2: ObservableObject {
    var people: [Student] = []
    func getPeople() {
        people = [
            Student(name: "john", exam: false),
            Student(name: "alisa", exam: true)
        ]
    }
    
    //尋找資料OK
    func printData() -> Bool {
        if people.count != 2 {
            return false
        }
        print(people[0])
        print(people[1])
        return true
    }
    
    func modifyStudentData() -> Bool {
        if people.count != 2 {
            return false
        }
        modifyItemByList(list: &people, index: 0, content: "123")
        modifyItemByList(list: &people, index: 1, content: "234")
        print("people[0].name \(people[0].name), 123")
        print("people[1].name \(people[1].name), 234")
        return true
    }
    
    func modifyItemByList(list people: inout [Student], index: Int, content: String) {
        people[index].name = content
    }
    
    //此方法可以測試看看，並無法實際修改資料
//    func modifyItemByListTest1(list people: [Student], index: Int, content: String) {
//        var item = people[index]
//        item.name = content
//    }
}

let school2 = School2()
school2.getPeople()
school2.printData()

print("-------Modify-------")
school2.modifyStudentData()
school2.printData()
//此處是inout的測試，可以嘗試把上方的註解拿掉，可以發現並無實際修改資料，因為不同記憶體了
