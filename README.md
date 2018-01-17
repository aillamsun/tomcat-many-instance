# tomcat-many-instance
tomcat-many-instance 是一个部署tomcat单机多实例工具，内涵脚本


-----

简单介绍一下各个文件夹及文件：

> * bin：主要存放脚本文件，例如比较常用的windows和linux系统中启动和关闭脚本
> * conf：主要存放配置文件，其中最重要的两个配置文件是server.xml和web.xml
> * lib：主要存放tomcat运行所依赖的包
> * LICENSE：版权许可证，软件版权信息及使用范围等信息
> * logs：主要存放运行时产生的日志文件，例如catalina.out(曾经掉过一个大坑)、catalina.{date}.log等
> * NOTICE：通知信息，一些软件的所属信息和地址什么的
> * RELEASE-NOTES：发布说明，包含一些版本升级功能点
> * RUNNING.txt：运行说明，必需的运行环境等信息
> * temp：存放tomcat运行时产生的临时文件，例如开启了hibernate缓存的应用程序，会在该目录下生成一些文件
> * webapps：部署web应用程序的默认目录，也就是 war 包所在默认目录
> * work：主要存放由JSP文件生成的servlet（java文件以及最终编译生成的class文件）

	上面是一个安装后的 Tomcat 的全部组成部分，如果你要启动，进入bin目录执行startup.sh就可以了，接着就可以在浏览器输入http://localhost:8080/访问了。那么问题来了：当你有了三个、五个以及十个应用服务需要同时部署到同一台服务器上时，你的 Tomcat 服务正确启动方式是什么？是把上面文件全部复制出 N 多个目录么？还是有其他处理方式呢？

-----

# Tomcat 常见的几种部署场景

通常，我们在同一台服务器上对 Tomcat 部署需求可以分为以下几种：单实例单应用，单实例多应用，多实例单应用，多实例多应用。实例的概念可以理解为上面说的一个 Tomcat 目录。

> * 单实例单应用：比较常用的一种方式，只需要把你打好的 war 包丢在 webapps目录下，执行启动 Tomcat 的脚本就行了。
> * 单实例多应用：有两个不同的 Web 项目 war 包，还是只需要丢在webapps目录下，执行启动 Tomcat 的脚本，访问不同项目加上不同的虚拟目录。这种方式要慎用在生产环境，因为重启或挂掉 Tomcat 后会影响另外一个应用的访问。
> * 多实例单应用：多个 Tomcat 部署同一个项目，端口号不同，可以利用 Nginx 这么做负载均衡，当然意义不大。
> * 多实例多应用：多个 Tomcat 部署多个不同的项目。这种模式在服务器资源有限，或者对服务器要求并不是很高的情况下，可以实现多个不同项目部署在同一台服务器上的需求，来实现资源使用的最大化。-


-----

## 使用说明
	> * 直接下载tomcat文件夹  放到自己服务器指定目录即可
	> * setEnv.sh无用 可以删除，把instance.sh 引入的位置注释即可

## 命令说明
	进入tomcat/script目录 若果没有权限 chmod 给脚本执行权限


### 添加实例 
```shell

./instance.sh -add 8100

```
会自动从template 目录将模版cp一份。同时在instances创建 8100实例目录, 自动将端口全部替换


### 启动实例
```shell

./instance.sh -start 8100
```

--- 访问http:localhost:8100

### 关闭实例
```shell
./instance.sh -stop 8100
```

### 启动所有实例
```shell
./instance.sh -startAll
```


### 关闭所有实例
```shell
./instance.sh -stopAll
```

### 删除实例
```shell
./instance.sh -remove 8100
```


### 删除所有实例
```shell
./instance.sh -removeAll 8100
```


### 查看当前所有实例
```shell
./instance.sh -list
```