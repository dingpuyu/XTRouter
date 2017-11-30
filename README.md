# XTRouter
A route that corresponds to a controller based on a schema hop

# XTRouter
一个iOS项目使用的路由跳转框架

## Demo

<center><img src="https://github.com/dingpuyu/XTRouter/blob/master/XTRouterProject/XTRouterProject/ScreenPrint/IMG_0233.PNG?raw=true" width = "375" height = "667" alt="Demo图" /></center>

### 通过schema从配置文件获取控制器

``` 
1.控制颜色
routerapp://home/huodong?color=CD5C5C
2.控制颜色和标题
routerapp://home/huodong?color=F0FFF0&title=我是标题一
3.网页跳转，网页链接需要做一个编码
routerapp://home/web?link=https%3A%2F%2Fwww.baidu.com
```

### Router的配置文件

配置文件中根目录为分类（huodong），进一级为具体页面（huodong,web），三级为参数名(pagename,defaultValueDict,paramsMapDict)。其中pagename为具体页面对应的控制器的名字，defaultValueDict放的是默认参数值，优先级较低，paramsMapDict放的是路径参数名与控制器参数的映射关系。配置完这些后，就可以根据schema链接去取控制器，然后做对应跳转。

![配置文件](https://github.com/dingpuyu/XTRouter/blob/master/XTRouterProject/XTRouterProject/ScreenPrint/20171130-101732.png?raw=true)

### 示例代码

```
UIViewController* vc = [[XTRouter shareInstance] controllerWithSchema:@"routerapp://home/huodong?color=CD5C5C&title=我是红色控制器"];
[self.navigationController pushViewController:vc animated:YES];
```
跳转效果

<center><img src="https://github.com/dingpuyu/XTRouter/blob/master/XTRouterProject/XTRouterProject/ScreenPrint/IMG_0234.PNG?raw=true" width = "375" height = "667" alt="红色控制器" align=center /></center>


