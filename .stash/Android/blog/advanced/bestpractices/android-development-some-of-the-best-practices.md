> 本文是一篇属于Opinionated的文章，只是代表了作者的个人观点，笔者看到Medium有两人发了都是关于最佳实践的Checklist，就把二者集成了下，并且加入了一些个人的看法，基本的知识点分布方式参考了：[我的知识体系架构](https://segmentfault.com/a/1190000004612590)。还是要强调下，本文的观点/评价只是属于个人观点，欢迎讨论。

> [android-development-some-of-the-best-practices-by-Abderrazak Laanaya](https://medium.com/android-news/android-development-some-of-the-best-practices-27722c685b6a#.wilgywfmw)

> [android-development-some-of-the-best-practices-jun-2016-edition-by-Stepan Goncharov](https://medium.com/@stepango/android-development-some-of-the-best-practices-jun-2016-edition-e505a0558a71#.6pads983b)



# Language:基本的语法

- 使用任何的第三方库之前都要三思而行，从笔者自己的经验里，抽象漏洞定理是一个颠仆不破的定理啊。虽然很多库宣扬的都是非常Nice，Demo也很诱人，但是你压根不知道它到底会带来怎样的Side Effect。笔者是建议如果真的打算应用某个库到正式的大型项目中，一定要好好考量下它的社区和活跃度。以后流的泪，都是当时脑子进的水。

- 尽量使用那些较小的，往往只是完成单个功能的库，将来比较好替换。

- Stepan Goncharov建议使用 [**Kotlin**](https://kotlinlang.org/)，可以帮你省掉很多譬如懒加载等等JDK未提供的功能。不过笔者表示持保守态度，毕竟学习成本上来了，就像当年LinkedIn转到Scala一样，谁知道未来会咋样呢？而且Java8，9之后Java本身也在逐步完善，如果真的需要很多附加功能，我觉得Lombok就不错。

- 给方法命名的时候尽量清晰点，不能随意命名

- 不要使用Guava

- 使用[Parcel](https://github.com/rharter/auto-value-parcel)在Android中引入[AutoValue](https://github.com/google/auto/blob/master/value/userguide/index.md)

- FlatBuffers是一个高效地跨平台序列化框架，而Serializable虽然方便使用，但是效率低下

# UI

- 使用Picasso或者Glide来作为图片容器

- 使用[Lint](https://developer.android.com/studio/write/lint.html)来辅助进行布局与层次优化，这样有助于发现冗余的布局

- 使用`styles`来减少布局XML中的重复属性

- 不要使用层次过深的ViewGroups继承

- Launch Screen是用户看到的第一个画面，要谨慎，不过也不能在没必要的时候强行加入一个Launch Screen

- 使用[ConstraintsLayout](http://tools.android.com/tech-docs/layout-editor)来扁平化视图层次

- 使用[数据绑定](https://developer.android.com/topic/libraries/data-binding/index.html)来减少UI代码的数目

- 避免在AsyncCallback以及静态对象中引用View，并且避免将View放入没有明确的内存模式的集合中，可以考虑放到WeakHashMap中



# Network

- 不要尝试着重复造轮子，可以使用Volley或者OkHTTP，可以考虑使用Retrofit作为上层封装

- 记得监控当前连接类型，在Wifi下进行较大量的数据更新

# Storage

- 使用[AccountManager](http://developer.android.com/reference/android/accounts/AccountManager.html)来建议登录名与Email地址等



## DataBase

- 除非确实有必要，否则不要盲目的引入数据库支持。这一点笔者也是赞同的，很多时候简单的缓存可以用SharedReference就可以了。不过反过来，如果你真的有一定的需要持久化的数据，不要犹豫，立马引入数据库的支持

- 如果引入了DB支持，那考虑使用[ORM](https://github.com/Raizlabs/DBFlow)框架的支持，避免重复造轮子

- 关于Realm，这是一个很炫的东西，但是笔者自己老实说在Android和iOS平台引入之后，发现还是会存在一些问题Abderrazak Laanaya对Realm是持积极态度而Stepan Goncharov是保守态度。笔者自己的感觉是Realm确实很酷，但是一定要做好其引发未知Crash的心理准备



# SysProc

- 使用RxJava来代替AsyncTasks，不过对于RetroLambda的使用还是持保留意见

- 对于Event Bus的使用持谨慎态度，一不小心就可能把你的程序变得有些杂乱，可以考虑使用RxJava+

LocalBroadcastManager作为替代

- 不要把太多东西塞入到Application线程中

- 使用[JobScheduler](https://www.youtube.com/watch?v=QdINLG5QrJc)来处理长期周期化运行的无状态任务

- 在应用程序中要注意避免[Memory Leaks](https://softorchard.wordpress.com/2015/08/08/avoid-memory-leaks-android/)，不过`onLowMemory()`是会在整个系统的内存较低的情况下被触发，因此不能用于避免OOMs

- 系统的30%的电量消耗用在了图片、动画等，而70%用于分析、广告、地图以及GPS



# TestRelease

- 现在的应用程序很容易突破65K的方法数量的限制，Multidexing可以帮你解决这个问题

- 应该按照Feature打包，而不应该按照Layers打包

- 使用Gradle以及其推荐的项目结构，并且将密码以及其他关键数据放置到gradle.properties中

- 将应用分为多个较小灵活地模块中，这样可以尽量保证可维护性较好、耦合度较低的CodeBase，也可以选择将小的模块发布到[公开或者私有的仓库中](https://www.jfrog.com/open-source/#os-arti)，然后在主项目中引入。

- 使用如下的表达式来过滤日志：

```

^(?!(NotificationManager|Timeline|SensorManager|Configs|libc-netbsd|art|stetho|Choreographer|CliptrayUtils|BubblePopupHelper|ViewRootImpl|libEGL|System.out|PhoneWindow))

```

- 在CI工具里添加些[静态的代码分析工具](http://www.sonarqube.org/)

- 开发的时候设置`minSdkVersion=21`，这样可以[加速编译时间](http://stackoverflow.com/questions/30776671/speed-up-gradle-build-in-multidex-application)，特别是在设置了Multidexing的时候

- 使用[Stetho](http://facebook.github.io/stetho/)来方便调试应用













