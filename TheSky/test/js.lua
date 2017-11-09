1.
function printArgs() {
    console.log(arguments);
}
 
printArgs("A", "a", 0, { foo: "Hello, arguments" });

结果  
["A", "a", 0, Object]

2.
arguments 表示的内容，其表示了函数执行时传入函数的所有参数。
在上面的例子中，代表了传入 printArgs 函数中的四个参数，
可以分别用 arguments[0]、 arguments[1]… 来获取单个的参数。

3.
arguments.length 来获得传入函数的参数个数

    //slice 经常用来将 array-like 对象转换为 true array。在一些框架中会经常有这种用法。
4.  //Array.prototype.slice.call(arguments);//将参数转换成真正的数组.
arguments 转数组    Array.prototype.slice.call(arguments); 或者  [].slice.call(arguments);
    //因为arguments不是真正的Array,虽然arguments有length属性，但是没有slice方法，所以呢，Array.prototype.
    //slice（）执行的时候，Array.prototype已经被call改成arguments了，因为满足slice执行的条件(有length属性).
5.
const obj = { 0: "A", 1: "B", length: 2 };
const result = [].slice.call(obj);
console.log(Array.isArray(result), result);

结果  true ["A", "B"]

从上面例子可以看出，条件就是： 1) 属性为 0，1，2…；2） 具有 length 属性；

6.
不能将函数的 arguments 泄露或者传递出去

// Leaking arguments example1:
function getArgs() {
    return arguments;
}
 
// Leaking arguments example2:
function getArgs() {
    const args = [].slice.call(arguments);
    return args;
}
 
// Leaking arguments example3:
function getArgs() {
    const args = arguments;
    return function() {
        return args;
    };
}

7.
JavaScript 中没有重载,可以利用 arguments 模拟重载

function add(num1, num2, num3) {
    if (arguments.length === 2) {
        console.log("Result is " + (num1 + num2));
    }
    else if (arguments.length === 3) {
        console.log("Result is " + (num1 + num2 + num3));
    }
}

8.
默认参数对 arguments 没有影响，arguments 还是仅仅表示调用函数时所传入的所有参数。
function func(firstArg = 0, secondArg = 1) {
    console.log(arguments[0], arguments[1]);
    console.log(firstArg, secondArg);
}
 
func(99);

99 undefined
99 1

9.
Array.from() 是个非常推荐的方法，其可以将所有类数组对象转换成数组。

10.数组与类数组对象

数组具有一个基本特征：索引。这是一般对象所没有的。

const obj = { 0: "a", 1: "b" };
const arr = [ "a", "b" ];

我们利用 obj[0]、arr[0] 都能取得自己想要的数据，但取得数据的方式确实不同的。
obj[0] 是利用对象的键值对存取数据，而arr[0] 却是利用数组的索引。
事实上，Object 与 Array 的唯一区别就是 Object 的属性是 string，而 Array 的索引是 number。

11.
类数组对象

伪数组的特性就是长得像数组，包含一组数据以及拥有一个 length 属性，但是没有任何 Array 的方法。
再具体的说，length 属性是个非负整数，上限是 JavaScript 中能精确表达的最大数字；另外，类数组对象的 length 值无法自动改变。

function Foo() {}
Foo.prototype = Object.create(Array.prototype);

const foo = new Foo();
foo.push('A');
console.log(foo, foo.length);
console.log("foo is Array ?" +Array.isArray(foo));

["A"] 1
foo is Array ? false

Foo 的示例拥有 Array 的所有方法，但类型不是 Array
如果不需要 Array 的所有方法，只需要部分怎么办呢？

function Bar() {}
Bar.prototype.push = Array.prototype.push;
 
const bar = new Bar();
bar.push('A');
bar.push('B');
console.log(bar);

Bar {0: "A", 1: "B", length: 2}


12.
obj1.func.call(obj)

obj看成obj1,调用func方法


function asum(a, b,  callback){
    const r = a + b;
    setTimeout(function(){
        callback(r);
    }, 0);
}

// 统计一个字符串出现次数最多的字母
function findMaxDuplicateChar(str)
    if(str.length == 1){
        return str;
    }

    let charObj = {};
    for (var i = 0 ; i < str.length - 1; i++) {
        if (!charObj[str.charAt(i)]) {
            charObj[str.charAt(i)] = 1;
        } else {
            charObj[str.charAt(i)] += 1;
        }
    }

    let maxChar = ""
    maxValue = 1;

    for (var k in charObj) {
        if (charObj[k] >= maxValue) {
            maxChar = k;
            maxValue = charObj[k];
        }
    }

    return maxChar;
end


//快排
function quickSort(arr) {
    
    if (arr.length <= 1) {
        return arr;
    }

    let leftArr = [];
    let rightArr = [];
    let q = arr[0];

    for (var i = 0; i < arr.length; i++) {
        if (arr[i] > q) {
            rightArr.push(arr[i]);
        } else {
            leftArr.push(arr[i]);
        }
    }

    return [].concat(quickSort(leftArr),[q],quickSort(rightArr));
}

//inherit的内部实现  
function inherit(p){
    if(p == null) throw TypeError();
    if (Object.create) {
        return Object.create(p);
    }
    var t = typeof p;
    if (t != "object" && t != "function") throw TypeError();
    function f() {};
    f.prototype = p;
    return new f();
}

//forEach()按照索引的顺序传递给定义的一个函数
var demoList =[1,2,3,4,6];
var sum = 0;
demoList.forEach(function (t) {
    sum = t*t;
});
// map()将调用的数组的每个元素传递给指定的函数，返回一个数组，它包含该函数的返回值。（返回新数组，不修改调用数组）
// filter()


// splice() 的第一个参数指定了插入或删除的起始位置。第二个参数指定了应该从中删除的元素个数。
// 如果省略第二个参数，从起始点开始到数组结尾的所有元素都将被删除。splice()返回一个由删除元素组成的数组，
// 或者如果没有删除元素就返回一个空数组。
// (>=3个参数）前两个参数指定了需要删除的数组的元素，紧跟其后的任意个数的参数指定了需要插入的元素。
// 从第一个参数指定位置开始插入，第二个参数是从第一个参数位置处开始删除元素的个数。












