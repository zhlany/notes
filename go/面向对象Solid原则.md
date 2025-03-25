## (L)里式替换原则

子类对象必须能够替换其父类对象，而不会破坏程序的正确性

**简称：继承**
但go中没有继承，用组合

理解：类型 S 实现了接口 T，那么类型 S 的实例应该可以替换接口 T 的任何使用，而不会改变程序的正确性

**案例**

```go
type Shape interface {
    Area() float64
}

type Rectangle struct {
    width, height float64
}

func (r *Rectangle) SetWidth(width float64) {
    r.width = width
}

func (r *Rectangle) SetHeight(height float64) {
    r.height = height
}

func (r Rectangle) Area() float64 {
    return r.width * r.height
}

type Square struct {
    size float64
}

func (s *Square) SetSize(size float64) {
    s.size = size
}

func (s Square) Area() float64 {
    return s.size * s.size
}

func PrintArea(s Shape) {
    fmt.Println("面积:", s.Area())
}

func main() {
    r := &Rectangle{width: 5, height: 4}
    PrintArea(r) // 20
    
    s := &Square{size: 5}
    PrintArea(s) // 25
}
```





## (d)依赖倒置原则

1. 高层次的模块不应依赖低层次的模块，他们都应该依赖于抽象。
2. 抽象不应依赖于具体实现，具体实现应依赖抽象

***通俗易通：***

```
底层实现，上层使用

//分解为：
1.创建接口，接口内包含方法
2.底层实现方法
3.业务层调用使用方法
```

**实现依赖倒置原则的关键：**

1. 定义清晰的接口（抽象）
2. 高层模块通过接口使用功能
3. 低层模块实现接口
4. 使用依赖注入来组装各个模块

这种设计使得系统更加灵活、可扩展和易于测试，符合软件工程的高内聚低耦合原则。

**案例1.**

```go
package main

import "fmt"

// 定义抽象接口
type Database interface {
    Save(data string)
}

// MySQL 实现
type MySQL struct{}

func (m *MySQL) Save(data string) {
    fmt.Printf("MySQL 保存: %s\n", data)
}

// MongoDB 实现
type MongoDB struct{}

func (m *MongoDB) Save(data string) {
    fmt.Printf("MongoDB 保存: %s\n", data)
}

// 业务逻辑
type BusinessLogic struct {
    db Database // 依赖接口而非具体实现
}

func (b *BusinessLogic) Process(data string) {
    fmt.Println("处理业务逻辑...")
    b.db.Save(data)
}

func main() {
    // 使用 MySQL
    mysqlLogic := BusinessLogic{db: &MySQL{}}
    mysqlLogic.Process("订单数据1")
    
    // 使用 MongoDB
    mongoLogic := BusinessLogic{db: &MongoDB{}}
    mongoLogic.Process("订单数据2")
    
    // 可以轻松切换数据库实现而不需要修改业务逻辑
}
```

**案例2:依赖注入**

```go
package main

import "fmt"

// Database 接口
type Database interface {
    Save(data string) error
    Get(id string) (string, error)
}

// MySQL 实现
type MySQL struct{}

func (m *MySQL) Save(data string) error {
    fmt.Printf("MySQL 保存: %s\n", data)
    return nil
}

func (m *MySQL) Get(id string) (string, error) {
    return fmt.Sprintf("MySQL 数据: %s", id), nil
}

// 业务服务
type OrderService struct {
    db Database
}

func NewOrderService(db Database) *OrderService {
    return &OrderService{db: db}
}

func (s *OrderService) CreateOrder(orderData string) error {
    // 业务逻辑...
    return s.db.Save(orderData)
}

func (s *OrderService) GetOrder(orderID string) (string, error) {
    return s.db.Get(orderID)
}

func main() {
    // 初始化依赖
    db := &MySQL{}
    
    // 注入依赖
    orderService := NewOrderService(db)
    
    // 使用服务
    orderService.CreateOrder("新订单")
    data, _ := orderService.GetOrder("123")
    fmt.Println(data)
}
```



## (i)接口分离原则

## (o)开放封闭原则

## (s)单一责任原则