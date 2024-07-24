# flutter_chat_DAPP  去中心化聊天程序
> 这是一款致力于隐私保护的去中心化聊天的跨平台应用程序。
>

## 特性
* **去中心化**
* **微服务架构**
* **布局自适应**
* **可拓展插件化**
* **易扩展**
* **模块化**
* **接口化**
* **本地化存储**
* **存储及通信加密化，连接通讯更安全**

## 系统架构

## 目录结构

> 说明：该项目基座基于[flutter_app_all_template](https://github.com/gnu-xiaosong/flutter_app_all_template)项目，具体目录结构请参阅该项目说明。因此本目录只详述microService目录

```markdown
├─module          模块目录: 主要为调制service中server与client的调制整合模块
├─service         服务逻辑目录: 主要为除开UI部分的实现业务逻辑，主要面向后台逻辑处理，不进行UI交互处理
│  ├─client         client服务
│  └─server         server服务
└─ui              用户交互UI目录: 主要用户实现UI界面，调用service服务
    ├─client            单个client端应用
    │  ├─common           公共目录
    │  ├─component        组件目录
    │  ├─module           模块目录
    │  ├─page	          页面page目录
    │  └─widget           项目所有用到的widget目录
    ├─server	        单个server端应用	
    │  ├─common 
    │  ├─component
    │  ├─module
    │  ├─page
    │  └─widget
    └─server_and_client  server与client端整合应用
        ├─common
        ├─component
        ├─module
        ├─page
        └─widget
```

## 使用说明

## 技术栈

#### 去中心化实现

### 可拓展

#### 通讯加解密

### 系统设计

## 模块划分

### Server模块

#### 新增自动处理其他类型消息

> 提示：每次在other目录下编写自定义消息类后，都要执行命令以进行自动代码生成

1. 在目录`/lib/microService/service/server/websocket/messageByTypeHandler`下编写server端消息类型处理类

   注意：文件名要与类型一致

2. 类必选函数和参数

   | 必选                                                         | 类型     | 类别 |                                                              |
   | ------------------------------------------------------------ | -------- | ---- | ------------------------------------------------------------ |
   | type                                                         | MsgType  | 属性 | 枚举类型， 具体见OtherMsgType.dart    自定义消息类别 当客户端采用如下格式传输消息文本时，type类型名要与上面生成的枚举名一样 |
   | void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) | function | 方法 | 处理消息接收处理逻辑：接受参数msgDataTypeMap, clientObject   |

   属性: String type

   方法：

   ```dart
   void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
     //
   }
   ```

   完整：

   ```dart
   /*
   websocket  server与client通讯 自定义消息处理类: TEST消息类型
    */
   import 'package:app_template/microService/service/server/websocket/other/TypeMessageClientHandler.dart';
   
   class TestTypeWebsocketCommunication extends TypeWebsocketCommunication {
     String type = "TEST";
     void handler(msgDataTypeMap, clientObject) {
       //
     }
   }
   ```

   其中**TestTypeMessageServerHandler**为实例文件类，按照该模版编写即可

3. 运行该命令生成代码：切换到项目根目录下

   `dart run .\bin\genOtherServerMsgTypeClass.dart`

  **消息类型与文件命名规则说明**：

每一个文件名命名规则为: `驼峰命名消息类型 + TypeMessageHandler`

代执行带生成的时候将会将`TypeMessageHandler`删除，留下剩余部分然后会按照如下规则生成消息枚举常量：

- 单驼峰：直接转变为大写形成枚举

- 多驼峰: 每个驼峰之间增加`_`, 然后再转为大写字母

例子：

- 单驼峰: `TestTypeMessageHandler` --> `Test` -->`TEST`  
- 多驼峰: `RequestInlineClientTypeMessageHandler`--> `RequestInlineClient` --> `Request_Inline_Client` -->`REQUEST_INLINE_CLIENT`

提示： 当客户端采用如下格式传输消息文本时，type类型名要与上面生成的枚举名一样

```json
{
   "type": "REQUEST_INLINE_CLIENT", //必选字段,字母不区分大小写，Test = TEST = TeST
   .....  其他可选字段
}
```

> **注意：** 对于具体的加解密算法没有提供，因为取决于client端加密的算法，如果client默认采用的本程序提供的普通消息加解密算法，可以直接调用基类TypeWebsocketCommunication中的enSecretMessage()和deSecretMessage()方法进行加解密，否则只能自己实现加解密算法。

### Client模块

#### 新增自动处理其他类型消息

> 提示：每次在other目录下编写自定义消息类后，都要执行命令以进行自动代码生成

1. 在目录`/lib/microService/service/client/websocket/other`下编写server端消息类型处理类

   注意：文件名要与类型一致

2. 类必选函数和参数

   | 必选                                                        | 类型            | 类别 |                                                              |
   | ----------------------------------------------------------- | --------------- | ---- | ------------------------------------------------------------ |
   | type                                                        | MsgType枚举类型 | 属性 | 自定义消息类别， 当客户端采用如下格式传输消息文本时，type类型名要与上面生成的枚举名一样 |
   | void handler(WebSocketChannel? channel, Map msgDataTypeMap) | function        | 方法 | 处理消息接收处理逻辑：接受参数msgDataTypeMap                 |

   属性: String type

   方法：

   ```dart
     void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
       // 解密info字段
       msgDataTypeMap["info"] = decodeAuth(msgDataTypeMap["info"]);
       //处理逻辑
       auth(channel, msgDataTypeMap);
     }
   ```

   完整：

   ```dart
   /*
   websocket  server与client通讯 自定义消息处理类: TEST消息类型
    */
   class TestTypeMessageHandler extends TypeMessageClientHandler {
     MsgType type = MsgType.TEST;
     void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
       //处理逻辑
     }
   }
   ```

   其中**TestTypeMessageHandler**为实例文件类，按照该模版编写即可

3. 运行该命令生成代码：切换到项目根目录下

   `dart run .\bin\genOtherClientMsgTypeClass.dart`

  提示： 与server类似使用

> **注意：** 对于具体的加解密算法没有提供，因为取决于client端加密的算法，如果client默认采用的本程序提供的普通消息加解密算法，可以直接调用基类TypeWebsocketCommunication中的enSecretMessage()和deSecretMessage()方法进行加解密，否则只能自己实现加解密算法

###  manipulator调制器模块

### strategy决策器模块

## 模型划分

#### 功能体模型

### 层级模型

### 模块模型
































## 详细设计及开发文档

### 用户表 (user)

用户表用来存储应用中所有用户的基本信息。

**字段说明**:

1. `id`: 用户的唯一标识符，通常是自增的整数。
2. `username`: 用户的用户名，必须是唯一的。
3. `email`: 用户的电子邮件地址，也必须是唯一的。
4. `password_hash`: 用户的密码哈希值，确保密码安全。
5. `created_at`: 账户创建时间戳。
6. `updated_at`: 用户信息的最近更新时间戳。
7. `profile_picture`: 用户的头像URL（可选）。
8. `status`: 用户当前的状态（在线、离线、勿扰等）（可选）

##### sql语句：

```sql
CREATE TABLE user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    profile_picture VARCHAR(255),
    status VARCHAR(50)
);
```

### 消息表 (chat)

消息表用来存储应用中所有的聊天消息。

**字段说明**:

1. `id`: 消息的唯一标识符，通常是自增的整数。
2. `sender_id`: 发送消息的用户ID，外键关联到 `user` 表的 `id`。
3. `receiver_id`: 接收消息的用户ID，外键关联到 `user` 表的 `id`。如果是群组聊天，可以用此字段存储群组ID。
4. `content`: 消息的文本内容。
5. `created_at`: 消息发送的时间戳。
6. `is_read`: 表示消息是否已被接收者阅读。
7. `message_type`: 消息的类型（文本、图片、文件等）。

##### sql语句：

```sql
CREATE TABLE chat (
    id SERIAL PRIMARY KEY,
    sender_id INT NOT NULL REFERENCES user(id) ON DELETE CASCADE,
    receiver_id INT NOT NULL REFERENCES user(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    message_type VARCHAR(50) DEFAULT 'text'
);
```

##### 表定义类

UserTable.dart 文件

ChatTable.dart文件

### 数据库设计细节与约束

1. **关系与外键**:
   - `chat` 表中的 `sender_id` 和 `receiver_id` 都是 `user` 表的外键，这样可以确保每条消息都有有效的发送者和接收者。
   - 使用 `ON DELETE CASCADE` 确保当用户被删除时，相关的消息也会被自动删除，避免孤立记录。
2. **索引**:
   - 为 `user` 表的 `username` 和 `email` 字段创建唯一索引，以确保这些字段的唯一性。
   - 为 `chat` 表中的 `sender_id` 和 `receiver_id` 创建索引，可以加快按用户查询消息的速度。
3. **时间戳**:
   - `created_at` 字段记录了记录的创建时间，这在消息排序和用户注册时间上非常重要。
   - `updated_at` 字段在 `user` 表中帮助记录最后的更新时间。
4. **数据安全与隐私**:
   - `password_hash` 存储用户密码的哈希值而不是明文，增强了安全性。
   - 对于聊天应用，保持数据的安全和隐私是至关重要的，确保对敏感数据的适当加密和保护。
5. **扩展性**:
   - 可以在 `user` 表中添加更多的字段以支持附加功能（如用户的偏好设置、个人描述等）。
   - 在 `chat` 表中，可以通过 `message_type` 字段扩展消息类型，以支持多媒体消息、文件等。



## websocket服务端设计

websocket server服务端处理总消息队列的策略

1. **被动触发**：在listen中监听到消息时被动立即转发该消息，不需要建立新的线程专门处理消息队列，容易造成阻塞
2. **循环任务**：建立新线程专门处理消息队列，优点在于不会造成阻塞，难点在于怎样处理线程之间的通信



##### client客户端扫描scan

client**端**

```json
{
	"type": "SCAN",
	"info": {
		"msg": "scan server task!"
	}
}
```

server端

```json
{
	"type": "SCAN",
	"info": {
		"code": 200,
		"msg": "I am server for websocket!"
	}
}
```

##### 客户端请求认证auth: 采用加密算法比较

```
算法规则: data_["info"]["key"] + data_["info"]["plait_text"]  使用md5加密生成encrypte
```

client端

```json
{
	"type": "AUTH",
	"deviceId": "设备唯一性id",
	"info": {
		"plait_text": "vsdvsbvsavsdvdxbdbdxbfdbsbvdfbd",
		"key": "this is auth key for encode"，
        "encrypte": "sjkvsbkjdvbsdjvhbsjhvbdsjhvbsdjhvbsdjhvbsdvjs"
	}
}
```

server端返回

```json
{
	"type": "AUTH",
	"info": {
		"code": "300",
		// 200 for successful !
		"msg": "this websocket client auth is not pass!"
	}
}

成功
{
	"type": "AUTH",
	"info": {
		"code": "200",
		// 代表成功
		"secret": secret,
		//通信秘钥
		"msg": "this websocket client auth is  pass!"
	}
}
```

##### 通讯方式：Queue队列存储形式



通讯秘钥认证失败

```json
{
	"type": "SECRET",
	"info": {
		"code": 400,
		"msg": "secret is not pass!"
	}
}
```

通用消息

```json
{
	"type": "MESSAGE",
	"info": {
        "msgType": "text", // 消息类型: text,file,link......
		"sender": {
			"id": "user123",// 设备唯一标识
			// 发送者的唯一标识符
			"username": "Alice",
            "role":  "角色", // admin(管理员), agent(坐席), moderator(版主), user(用户)
			// 发送者用户名
			"avatar": "avatar.jpg" // 发送者头像（可选）
		},
		"recipient": {
			"id": "all", // 设备唯一标识
			// 接收者的唯一标识符，可以是 all 表示广播给所有用户
			"type": "group" // 接收者类型，例如 group 表示群组消息，user 表示私聊消息
		},
		"content": {
			"text": "Hello, World!",
			// 文本消息内容
			"attachments": [ // 附件列表，如图片、文件等（可选）
			{
				"type": "image",
				"url": "https://example.com/image.jpg",
				"name": "image.jpg"
			}]
		},
		"timestamp": "2024-06-14T15:30:00Z",
		// 消息发送时间戳
		"metadata": {
			"messageId": "msg123",
			// 消息的唯一标识符
			"status": "sent" // 消息状态，例如 sent, delivered, read
		}
	}
}
```

##### 请求在线客户端client

client端发起请求

```
{
	"type": "REQUEST_INLINE_CLIENT",
	"info": {
		"deviceId": "",
		//请求客户端的设备唯一性id
	}
}
```

server端响应

```
{
	"type": "REQUEST_INLINE_CLIENT",
	"info": {
		"deviceId": [],// 在线设备唯一性id list，不包括本机deviceId
	}
}

```

##### server端主动广播在线的用户设计

- 触发点: 有新用户连接或有用户断开

- 函数设计：

  server广播

  ```dart
   // 数据封装
  Map msg = {
      "type": "BROADCAST_INLINE_CLIENT",
      "info": {"type": "list", "deviceIds": deviceIdList}
  };
  ```

- 关键代码

  ```dart
    Future<void> receiveInlineClients() async {
      print("******************处理从server接收到的在线client***********************");
      // 1.获取deviceId 列表
      List<String> deviceIdList = msgDataTypeMap["info"]["deviceIds"];
      // 2.与数据库中对比:剔除一部分
      List deviceIdListInDatabase = await userChat.selectAllUserChat();
      Set<String> deviceIdList_set = deviceIdList.toSet();
      Set<String> deviceIdListInDatabase_set =
          deviceIdListInDatabase.map((e) => e.toString()).toSet();
      // 集合取交集
      Set<String> commonDeviceIds =
          deviceIdList_set.intersection(deviceIdListInDatabase_set);
      // 3.将其存入缓存中
      List<String> commonList = commonDeviceIds.toList();
      GlobalManager.appCache.setStringList("deviceId_list", commonList);
      // 4.创建为每个clientObject对象，采用list存储
      for (String deviceId in commonList) {
        // 判断全局变量中是否存在该队列
        if (!GlobalManager.userMapMsgQueue.containsKey("")) {
          // 不存在，创建
          GlobalManager.userMapMsgQueue[deviceId] = MessageQueue();
        }
      }
  
      printInfo("userMapMsgQueue count:${GlobalManager.userMapMsgQueue.length}");
    }
  ```

  > 注: 根据该设计可知，以后聊天业务只需面向该map用户消息队列编程即可，便于解耦





##### 扫码加好友设计

<img src="project/README/image-20240618230120303.png" alt="image-20240618230120303" style="zoom: 67%;" />



- 消息json设计

  ```json
   {
       "type": "REQUEST_SCAN_ADD_USER",
       "info": {
           "type":"", // 类型：request、response  请求方还是相应方
           "status": "", //状态: agree、disagree,wait  消息状态，用于标识
           "confirm_key": "确认秘钥", // 确认秘钥，用于验证相应方是否有效，
           // 发送方：扫码方
           "sender": {"id": send_deviceId, "username": qr_map["username"], "avatar": “头像"},
           // 接收方: 等待接受
           "recipient": {"id": qr_map["deviceId"], "username": AppConfig.username, "avatar": “头像"},
           // 留言
           "content": qr_map["msg"] // 这个字段不是二维码扫描出的，而是用户自定义加上去的
       }
   }
  ```

  









##### server消息任务调度设计

![image-20240614174920349](project/README/image-20240614174920349.png)**矩阵式调度client的消息进入总线的消息队列**

**调度策略：**

* **横向(client调度)**：按重要度进行调度选取（何为重要性则需要自行选取）
* **纵向(消息调度)**：单个client客户端消息队列设计，一般采用时间先后顺序。

创新调度方法：采用人工智能调度

##### 总消息队列设计

* **在线client消息队列**
* **离线client消息队列**：负责各类的离线信息调度，进入其消息队列的**msg的info字段已进行加密处理**

> 根据message所标识的接受者信息[这里采用设备的唯一id作为依据]选择其对应clientObject对象，
> 这里有个策略选择：如果接受者处于断线状态怎么处理，如下策略解决，推荐策略1，这里选择权交给用户，用户自行选择策略
> 策略1: 采用建立一个离线状态信息的循环队列用于被动发送/主动发送，这里最好的策略为在用户连接成功server端后调用该循环信息队列,这会增加server端的存储压力
>   策略2:采用互信机制，只能在双方都处于在线状态时才能进行通讯，

关于离线消息队列两个核心点：

* 未在在线clientObject中找到的消息clientObject**是否进入离校消息队列**中
* **是否开启离线消息队列**，这里采用策略被动触发离线消息队列处理机制

##### 进入离线消息队列msg需要满足的字段条件：

```json
 {
     "type":"",
     "info":{
         // 接收者
         "recipient":{
             "id":"设备唯一性ID"
             .......
         },
         ........
     }
 }
```

##### 离线消息加密设计：两道加密防护



- 第一道：内存加密存储防护，自定义秘钥为key为该机的唯一性设备标识符作为加密秘钥key
- 第二道：传输解密防护,双方互信生成的秘钥key

![image-20240620143709304](project/README/image-20240620143709304.png)



##### Client端接收好友添加消息队列






##### 加密与加密

## 消息页面缓存设计

为每个通讯对象实体(普通用户、群主)设计一个用于缓存新消息的队列。只需要面向队列变成即可。

![image-20240615205821765](project/README/image-20240615205821765.png)



应用启动时，根据拥有用户数创建消息队列，关闭应用时清空消息队列



### server端作为client设计

##### 方案

- **方案一**(**目前方案**): 本地重启一个client客户端实例，server与client服务分离

  好处： 有力减少server与client的耦合，跟有利于分别维护server与client的代码，简单

  缺点:  增加server的中心设备的性能压力，不太推荐

  <img src="project/README/image-20240625172607076.png" alt="image-20240625172607076" style="zoom:50%;" />

- **方案二**(推荐,后续方案): 共用server的websokcet，但是需要修改部分代码，这里需要设计server与client的桥接通道类

  好处: 只需要利用server的websocket与client的通讯，有力较少其中心设备的能耗

  坏处: 其造成server与client代码交织在一起，耦合性强

  > 解决方法: 通过合理的代码设计有力较少server与client的代码耦合性

​		通过重写![image-20240625163025566](project/README/image-20240625163025566.png)

**要点：**

1. 消息不需要加解密
2. 采用原client基础上通过判断的方式
3. 

## 开发日历





## 开发日志

* **2024-7-23** 创建并初始化项目

* **2024-7-25**  重构项目： 但是存在一个bug，在小米9手机上关闭应用无法调用中端程序，另外手机正常调用了中断程序，小米9存在延迟，需要对方发送MESSAGE消息后才后调用终端程序。

  

  

