//:第一节 
//playground是用来测试的，不是用来开发的
//
import UIKit
//***********************************************1.变量和常量*************************************************************
var str = "Hello, playground"
//1.
var a = 1// 等号两边要空格就都空，要不空就都不空，因为swift是自动类型推断
let b = 2
a = 3
//b = 4
//其他编程语言采用的是ASCII编码方式，swift采用unicode编码方式
//var  😄＝"笑脸"
//var 都 ＝ "你好"

//*************************************************2.数据类型*********************************************************

//************************************************3.数组****************************************
var array1 = [1,2,3,4]
array1.append(5)
array1.insert(4, atIndex: 3)
array1.removeAtIndex(2)
array1[1...3] = [6,7]
print(array1)
//数组的遍历
for value in array1
{
    print(value)
}

for(index,value) in enumerate(array1)
{
    print("index = \(index),value = \(value)")
}


//*****************************************************4.元组********************************************************

var person = ("zhangsan",25,"广州")
print(person.1)
//实质就是定义了两个变量，name和address，将person这个元组里面的三个成员变量中的两个赋值给name和address，用下划线表示忽略
var (name,_,address) = person
print(name)
print(address)

//*****************************************************5.字典*************************************************************
//字典也是使用［］
var dictionary:Dictionary<String,String> = ["k1":"v1","k2":"v2","k3":"v3"]
print(dictionary)

//添加一个键值对，字典的键值对是无序的
//键值对不存在即为添加，存在即为修改
dictionary["k4"] = "v4"
print(dictionary)

//属性和方法的调用都是用点语法
dictionary.updateValue("value1", forKey: "k1")
print(dictionary)

//删除
dictionary.removeValueForKey("k4")
print(dictionary)

//获取全部的values和keys
print(dictionary.values)
print(Array(dictionary.values))


//***********************************************************6.可选类型****************************************************************************
//变量在定义之前要给初始值
//
//var f
//f = 0
//在变量的后面加上一个问号，表示可选类型，可以为nil
var number:Int?
var str1 = "123"
number = str1.toInt()
print(number)//optional(可选类型)
var number1 = number!  + 1 //表示解包，可选类型使用的时候需要使用！号解包取出来值再使用
print(number1)


//************************************************************7.流程控制********************************************************************************
var g = 1
//1.不存在非0即为真
//2.可以不写括号
if g == 1
{
    print("YES")
}else{
    print("NO")
}

//switch
//1.必须要考虑到所有情况，一般都必须要有default语句
//2.每个case里面最少只有一句代码
//3.每种case自带break
//4.需要贯穿的时候，需要用fallthrough关键字
//5.如果多个case一样，写在一起，用逗号隔开
var s = 2;
switch s
{
case 1:
    print("1")
case 2,3,4:
    print("2")
    fallthrough
default:
    print("其他")
    
}

//6.case可以是范围，而且可以交叉，交叉时只走第一种情况
var l = 10
switch l
{
case 1...15:
    print("1...15")
case 5...20:
    print("5...20")
default:
    print("else")
}

//7.case的双重判定
switch s
{
     case 1...15 where s == 2 :
      print("双重判断,s == 2")
    default:
       print("-------")
}

//8.case可以使用元组
var  point = (10 , 20)
switch point{
    case (10,20) :
        print("+++++++++++")
case (_,0):
    print("在x轴上")
case (0,_) :
    print("在y轴上")
default:
    print("else")
    
}






//************************************************************8.循环语句************************************************************
var flag = 0
for var i = 0;i<10;i++
{
    for var j = 0; j < 10 ;j++
    {
        print("i = \(i),j = \(j)")
        if i == 3 && j == 4
        {
            print("i = \(i),j = \(j)")
            flag = 1
            break//停止内层循环
        }
    }
    if flag == 1
    {
    break//停止外层循环
    }
}

//swift中标记的使用
aa: for var i = 0 ; i<10 ;i++
{
    for var j = 0; j<10; j++
    {
        print("i = \(i),j = \(j)")
        if i == 3 && j == 4{
            print("i = \(i),j = \(j)")
            break aa
        }
    }
}


//************************************************************9.函数************************************************************
//1.写在类外边的叫做函数，写在类里面的叫做方法
/*
func（函数的关键字） 函数名 （参数列表） －>返回值类型
｛

    语句块

｝
*/
func sayHi (name:String) ->String
{
    return name + "Hello"
}

//2.函数的调用
sayHi("zhangsan,")

//3.使用元组，可以实现多个返回值
func countNumber( ) -> (a:Int,b:Int){
    var A = 1,B = 2
    return (A,B)
}

var c = countNumber()
print(c.0)

//4.内部参数名
func PersonInfo (name:String,age:Int,address:String) -> String
{
    return name + "\(age)" + address
}

PersonInfo("张三,", 15, ",guangzhou")


//5.外部参数名
func PersonInfo1 (Name name:String, age:Int, #address:String) -> String
{
    return name + "\(age)" + address
}

PersonInfo1(Name: "lisi", 12, address: "beijing")

//6.参数不确定的函数
func numberValue(numbers:Double...) ->Double
{
    var sum = 0.0
    for n in numbers{
        sum += n
    }
    return sum
}

numberValue(1.1,42,15.5,4.0)

//7.传值和传址
func changeValue( var num:Int)
{
    num++
    print(num)
}

var m = 3
changeValue(m)
print(m)

//传地址
func changeValue1( inout num:Int)
{
    num++
    print(num)
}

var m1 = 3
changeValue1(&m1)
print(m1)

//8.函数的嵌套
func goOrBack( isGo:Bool) ->( Int ->String )//返回值是一个函数类型
{
    func go (g:Int) ->String
    {
        return "\(g)"
    }
    
    func back (b:Int) ->String
    {
        return  "BACKBACK"
    }
    
    return isGo ? go : back
}

//函数类型，就是c语言里面的函数指针
var step:(Int) -> String = goOrBack(true)

step(2)



//****************************************************10、闭包*************************************************************************************
////闭包是一个封闭式的代码块，类似于block
//闭包的语法格式  ｛ （参数列表） 返回值类型  in 返回值 ｝
var names = ["zhangsan","lisi","wangwu","zhaoliu"]
//正常的函数调用
func sortByName(s1:String,s2:String) -> Bool
{
    return s1 >  s2
}

var s3 = sorted(names, sortByName)
print(s3)

//闭包的形式实现数组排序
var s4 = sorted(names, { (s1:String, s2:String) -> Bool in
    s1 > s2
})
print(s4)
























