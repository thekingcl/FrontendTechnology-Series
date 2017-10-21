[TOC]

# Introduction

笔者没有把OkHttp归纳到Android体系内，还是放置到了Java体系内。Retrofit本身就是对于OkHttp的封装。

![](https://packetzoom.com/blog/images/httplibs.png)



## Comparison(比较)

> [comparison-of-android-networking-libraries-okhttp-retrofit-volley](http://stackoverflow.com/questions/16902716/comparison-of-android-networking-libraries-okhttp-retrofit-volley#)



目前基本上每个应用都会使用HTTP/HTTPS协议来作为主要的传输协议来传输数据。即使你没有直接使用HTTP协议，也会有成堆的SDK会包含这些协议，譬如分析、Crash反馈等等。当然，目前也有很多优秀的HTTP的协议库，可以很方便的帮助开发者构建应用，本篇博文中会尽可能地涵盖这些要点。Android的开发者在选择一个合适的HTTP库时需要考虑很多的要点，譬如在使用Apache Client或者HttpURLConnection时可能会考虑：



- 能够取消现有的网络请求

- 能够并发请求

- 连接池能够复用存在的Socket连接

- 本地对于响应的缓存

- 简单的异步接口来避免主线程阻塞

- 对于REST API的封装

- 重连策略

- 能够有效地载入与传输图片

- 支持对于JSON的序列化

- 支持SPDY、HTTP/2


最早的时候Android只有两个主要的HTTP客户端： [HttpURLConnection](http://developer.android.com/reference/java/net/HttpURLConnection.html), [Apache HTTP Client](https://developer.android.com/sdk/api_diff/22/changes/android.net.http.AndroidHttpClient.html)。根据Google官方博客的内容，HttpURLConnection在早期的Android版本中可能存在一些Bug:



> 在Froyo版本之前，HttpURLConnection包含了一些很恶心的错误。特别是对于关闭可读的InputStream时候可能会污染整个连接池。



同样，Google官方并不想转到Apache HTTP Client中：



> Apache HTTP Client中复杂的API设计让人们根本不想用它，Android团队并不能够有效地工作。



而对于大部分普通开发者而言，它们觉得应该根据不同的版本使用不同的客户端。对于Gingerbread(2.3)以及之后的版本，HttpURLConnection会是最佳的选择，它的API更简单并且体积更小。透明压缩与数据缓存可以减少网络压力，提升速度并且能够节约电量。当我们审视Google Volley的源代码的时候，可以看得出来它也是根据不同的Android版本选择了不同的底层的网络请求库：



``` java

if (stack == null) {

    if (Build.VERSION.SDK_INT >= 9) {

        stack = new HurlStack();

    }  else {

        // Prior to Gingerbread, HttpUrlConnection was unreliable.

        // See: http://android-developers.blogspot.com/2011/09/androids-http-clients.html

        stack = new HttpClientStack(AndroidHttpClient.newInstance(userAgent));

    }

}

```



不过这样会很让开发者头疼，2013年，Square为了解决这种分裂的问题发布了OkHttp。OkHttp是直接架构与Java Socket本身而没有依赖于其他第三方库，因此开发者可以直接用在JVM中，而不仅仅是Android。为了简化代码迁移速度，OkHttp也实现了类似于HttpUrlConnection与Apache Client的接口。



![](https://packetzoom.com/blog/images/okhttp.png)



OkHttp获得了巨大的社区的支持，以至于Google最终是将它作为了Android 4.4默认的Engine，并且会在5.1之后弃用Apache Client。目前OkHttp V2.5.0支持如下特性：



- HTTP/2 以及 SPDY的支持多路复用

- 连接池会降低并发连接数

- 透明GZIP加密减少下载体积

- 响应缓存避免大量重复请求

- 同时支持同步的阻塞式调用与异步回调式调用



笔者关于OkHttp最喜欢的一点是它能够将异步请求较好的展示：



``` java

private final OkHttpClient client = new OkHttpClient();



public void run() throws Exception {

    Request request = new Request.Builder()

        .url("http://publicobject.com/helloworld.txt")

        .build();



    client.newCall(request).enqueue(new Callback() {

        @Override 

        public void onFailure(Request request, Throwable throwable) {

        throwable.printStackTrace();

    }



    @Override 

      public void onResponse(Response response) throws IOException {

    if (!response.isSuccessful()) throw new IOException("Unexpected code " + response);

        System.out.println(response.body().string());

    }

  });

}

```



这个用起来非常方便，因为往往大的数据请求都不能放置在UI主线程中进行。事实上，从Android 3.0(Honeycomb 11)开始，所有的网络操作都必须强制在单独的线程中进行。在当时如果要把HttpUrlConnection和AsyncTask结合起来使用，还是比较复杂的。而2013年的Google I/O大会上，Google提出了Volley，一个提供了如下便利的HTTP库：



- Automatic scheduling of network requests.

- Multiple concurrent network connections.

- Transparent disk and memory response caching with standard HTTP cache coherence.

- Support for request prioritization.

- Cancellation request API. You can cancel a single request, or you can set blocks or scopes of requests to cancel.

- Ease of customization, for example, for retry and backoff.

- Strong ordering that makes it easy to correctly populate your UI with data fetched asynchronously from the network.

- Debugging and tracing tools.



![](https://packetzoom.com/blog/images/volley_arch.png)



Volley主要架构在HttpUrlConnection之上，如果希望能够抓取图片或者JSON数据，Volley有自定义的抽象类型ImageRequest与JsonObjectRequest，可以自动转化为HTTP请求。同时，Volley也有一个硬编码的网络连接池大小：



``` java

private static final int DEFAULT_NETWORK_THREAD_POOL_SIZE = 4;

```



不过OkHttp可以自定义连接池的大小：



``` java

private int maxRequests = 64;

private int maxRequestsPerHost = 5;



executorService = new ThreadPoolExecutor(0, Integer.MAX_VALUE, 60, TimeUnit.SECONDS,

      new LinkedBlockingQueue<Runnable>(), Util.threadFactory("OkHttp Dispatcher", false));

```



在某些情况下，OkHttp可以通过使用多线程来有更好的性能体现。不过如果现有的程序中已经用Volley做了顶层封装，那么也可以使用[HttpStack implementation](https://gist.github.com/bryanstern/4e8f1cb5a8e14c202750)这个来使用OkHttp的请求与响应接口来替换HttpUrlConnection。



到这里已经可以发现，OkHttp本质上是自定义了一套底层的网络请求架构。目前HTTP客户端已经逐步转化为了支持大量图片，特别是那种无限滚动与图片传输的应用。同时，REST API已经成为了业界标准，基本上每位开发者都需要处理大量标准化的任务，类似于JSON序列化与将REST请求映射到Java的接口上。Square也在不久之后针对这两个问题提出了自己的解决方案：



- [Retrofit](http://square.github.io/retrofit/) - **一个类型安全的HTTP客户端支持REST接口**

- [Picasso](http://square.github.io/picasso/) - **针对Android的图片下载与缓存库**



Retrofit 提供了一个面向Java代码与REST接口之间的桥接，可以迅速将HTTP API转化到Java接口中并且自动生成带有完整文档的实现：



``` java

public interface GitHubService {

    @GET("/users/{user}/repos")

    Call<List<Repo>> listRepos(@Path("user") String user);

}





Retrofit retrofit = new Retrofit.Builder()

    .baseUrl("https://api.github.com")

    .build();



GitHubService service = retrofit.create(GitHubService.class);

```



除此之外，Retrofit 也支持面向JSON、XML以及Protocol Buffers的数据转化。在[另一篇博客](http://instructure.github.io/blog/2013/12/09/volley-vs-retrofit/)中将AsyncTask与Volley以及Retrofit做了一个比较，其性能对比如下：



![](http://i.imgur.com/tIdZkl3.png)




# HttpClient

## [Volley][1]

> 参考资料
> 
> - [Android Volley全解析][2]

## Retrofit

> - [Effective OkHttp](http://omgitsmgp.com/2015/12/02/effective-okhttp/?utm_source=tuicool&utm_medium=referral)


# Serialization

## JSON

## FlatBuffers

> - [flatbuffers-in-android-introdution](http://frogermcs.github.io/flatbuffers-in-android-introdution/)
> - [json-parsing-with-flatbuffers-in-android](http://frogermcs.github.io/json-parsing-with-flatbuffers-in-android/)


# HTTP Stubs

## [AndroidStubServer](https://github.com/byoutline/AndroidStubServer)





[1]: https://github.com/mcxiaoke/android-volley
[2]: www.kwstu.com/ArticleView/kwstu_20144118313429