//
//  main.swift
//  LNSwift(2)
//
//  Created by ccyy on 15/7/14.
//  Copyright (c) 2015年 111. All rights reserved.
//

import Foundation

protocol PersonProtocol{
    //默认是必须实现的
    func description() ->String
}

//*************************************1.结构体***********************************

//1.定义一个点的结构体
struct Point {
    var x = 0
    var y = 0
}

//定义一个Size的结构体
struct Size {
    var width = 0
    var height = 0
}

//定义一个rect结构体
struct Rect:PersonProtocol{
    var origin = Point( )
    var size = Size( )
    
    
    //1.2构造函数 （就是OC里面的初始化方法）
    init ( x:Int,y:Int,w:Int,h:Int )
    {
        //将外部的实参赋值给成员变量
        self.origin = Point(x: x, y: y)
        self.size = Size(width: w, height: h)
        println("创建一个Rect对象")
    }
    
    //1.3在Rect结构体定义一个类方法，注意要用static修饰
    static func ClassMethod( )
    {
        println("这是一个结构体里面的一个类方法")
    }
    
    //1.4在结构体内部实现协议方法
    func description() -> String {
        println("这是结构里面的一个协议方法")
         return "这是结构里面的一个协议方法"
    }
}

//1.5结构体的使用
var frame = Rect(x: 0, y: 0, w: 100, h: 100)
Rect.ClassMethod()
frame.description()


//***********************************2. 类***********************************************

//Swift中属性有三种，存储属性，计算属性，类属性
class Person {
    //2.1.1 存储属性：类似于OC的实例变量，主要用来保存一个变量的值
    //如果一个属性在声明的时候没有赋值，那么在这个类的所有构造函数中都必须对属性赋值
    var age:Int = 20
    var chinesse = 0
    var math = 0
    var english = 0
    //2.1.2 延迟存储属性
     lazy  var f:file = file( )
    
    //2.2 计算属性：专门用来处理属性的数据的运算，提供get 和set方法
    //一定是变量，要用var来修饰，不需要初始值
    //通过get和set方法来处理值
    var sum:Int {
        get{
            return chinesse + math + english
        }
        set{
            
        }
    }
    
    //类属性，用class修饰，只能是计算属性，不能用存储属性
    class var description:String {
        get{
            println("这是一个类属性")
            return "这是一个人"
        }
    }
    
}

class file {
    init()
    {
        println("这是一个很大的文件")
    }
}

//创建一个Person类的对象
var p = Person( )
//计算属性的演示
p.chinesse = 20
p.math = 86
p.english = 88
println(p.sum)
//延迟存储属性
p.f = file()
//类属性
Person.description


//*****************************************3.方法****************************************************

class Person1 {
    var name:String! //加！号之后就不用再在所有初始化方法里赋值了
    var age:Int = 20
     //方法的重载：（OC中没有，借鉴了JAVA和C+）方法名一样，参数不一样（参数名和个数）
    //swift构造函数
    //默认的构造函数
    init( ){
        println("这是一个默认的构造函数")
//        self.name = ""
    }
    //自定义构造函数
    init( name:String,age:Int){
        self.name = name
        self.age = age
    }
    
// ---------------------------------------------
    //遍历构造器（实质是在加号方法里面调用了一个－号方法）
    convenience init (Name:String , Age:Int){
        //实质还是调用正常的构造函数
        self.init(name:Name,age:Age)
    }
    
    //析构函数，类似于OC的dealloc函数
    deinit{
        println("人死了")
    }
    
    func sleep(){
        println("睡觉")
    }

}

//使用自定义初始化方法
var p1 = Person1(name: "zhangsan", age: 15)
println(p1.name)
//遍历构造器的使用
var p2 = Person1(Name: "wangxiaobo", Age: 20)
println(p2.age)

//演示析构函数的作用
func newPerson(  )
{
    var p3 = Person1 ( )
}
println("函数调用前")
newPerson()
println("函数调用后")

//********************************************4.继承*****************************************************************
//:冒号表示继承关系
class Man:Person1
{
    //override表示重写父类的方法
    //子类重写父类方法，优先调用子类方法
    override init() {
        super.init()
        println("这是一个男人的初始化方法")
    }
}
var m = Man( )
m.name = "ccyy"
println(m.name)
m.sleep( )

//********************************************5.多态*****************************************************************

class Woman:Person1 {
    override func sleep() {
        println("这是一个女人在睡觉")
    }
    func eat () {
        println("女人在吃零食")
    }
    
}

//多态：父类指针指向子类对象
//为什么多态不能说成子类指针指向父类指针，因为子类里的方法有可能比父类多，Woman类比Person类方法多，woman类的指针能操作父类里的方法和自己的方法，person类就没有eat这个方法，虽然语法上没有错，但如果子类指针指向父类，找不到这个方法时候就会崩溃

var p4:Person1 = Woman()
//编译的时候，p4是Person1类型，运行的时候是Woman类型 
//多态的情况下，看谁开辟的内存空间，那么这个对象就是什么类型
p4.sleep()




























//*************************************************************************************************************
//*************************************************************************************************************
//*************************************************************************************************************














