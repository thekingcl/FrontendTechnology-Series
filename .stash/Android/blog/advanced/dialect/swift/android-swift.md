# Quick Start

> [Getting Started with Swift on Android](https://github.com/apple/swift/blob/master/docs/Android.md)



目前，Swift的标准库stdlib可以被编译运行在Android armv7环境下，这就意味着我们可以在一个承载着Android系统的移动设备上运行Swift代码。本部分也就是说明如何在Android设备上运行熟知的Hello World。如果你在实践的过程中发现了什么问题，可以在[这里](https://bugs.swift.org/)寻求帮助。

> 需要注意的是，虽然现在Swift编译器能够直接在Android设备上运行Swift代码，但是并不意味着你可以用Swift来直接写一个APP了。对于一个常见的APP而言还包含着大量的用户界面的构建，这并不是Swift stdlib所能支持的。不过你可以选择从Swift中调用Java的界面构造，但是这个和OJC与Swift之间的关系也不一样，Swift编译器并不能够对这一步进行优化。



## Prerequisites

首先，你需要准备以下的开发环境：

- 一个能够从源码编译Swift的Linux环境。目前stdlib仅支持在Linux环境下完成编译，你需要先保证你的环境能够成功按照Swift项目的README中的指示进行编译。

- Android NDK 21或者以上版本，在http://developer.android.com/ndk/downloads/index.html下载。

- 一个开启了远程调试的Android设备。我们需要用远程调试来部署stdlib编译好的版本，可以根据https://developer.chrome.com/devtools/docs/remote-debugging这个来启动远程调试。



## Hello World

### 构建Swift Android标准库依赖

首先我们需要构建以下标准库

```

apt-get install libicu-dev icu-devtools

```

另外为了构建libiconv与libic：

（1）确保已经安装了`curl`、`autoconf`、`automake`、`libtool`以及`git`工具。

（2）使用`git clone git@github.com:SwiftAndroid/libiconv-libicu-android.git`命令从项目中克隆下源代码。

（3）在命令行中运行`which ndk-build`，来确保部署好的NDK能够成功执行。

（4）进入`libiconv-libicu-android`目录然后启动`build.sh`脚本。

（5）确保在`libiconv-libicu-android`目录下出现了`armeabi-v7a/icu/source/i18n` 与 `armeabi-v7a/icu/source/common`两个文件夹。

### 构建Android的Swift stdlib

进入Swift文件夹，运行构建脚本，注意要传入Android NDK与libicu/libiconv目录：

```

$ utils/build-script \
    -R \                                           # Build in ReleaseAssert mode.
    --android \                                    # Build for Android.
    --android-ndk ~/android-ndk-r10e \             # Path to an Android NDK.
    --android-ndk-version 21 \                     # The NDK version to use. Must be 21 or greater.
    --android-icu-uc ~/libicu-android/armeabi-v7a/libicuuc.so \
    --android-icu-uc-include ~/libicu-android/armeabi-v7a/icu/source/common \
    --android-icu-i18n ~/libicu-android/armeabi-v7a/libicui18n.so \
    --android-icu-i18n-include ~/libicu-android/armeabi-v7a/icu/source/i18n/
```

### 编译`hello.swift`并且运行在Android设备上

- 创建一个简单的Swift文件，叫做`hello.swift`

```

print("Hello, Android")
```

- 使用Swift编译器进行编译，注意选择的目标要是Android

```

$ build/Ninja/ReleaseAssert/swift-linux-x86_64/swiftc \                   # The Swift compiler built in the previous step.
    -target armv7-none-linux-androideabi \                                # Targeting android-armv7.
    -sdk ~/android-ndk-r10e/platforms/android-21/arch-arm \               # Use the same NDK path and version as you used to build the stdlib in the previous step.
    -L ~/android-ndk-r10e/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a \  # Link the Android NDK's libc++ and libgcc.
    -L ~/android-ndk-r10e/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/lib/gcc/arm-linux-androideabi/4.8 \
    hello.swift
```

这一步骤最后会创建一个`hello`的可执行文件，如果你打算在Linux环境下运行该文件，可能出现以下错误：

```

cannot execute binary file: Exec format error
```

### 部署到设备上

你需要使用`adb push`命令来讲刚才构建好的可执行程序从Linux环境中复制到Android设备上。确保你的设备已经成功连接到了Linux系统上，可以使用`adb devices`命令进行验证，然后使用如下命令来讲Swift Android stdlib复制到设备上：

``

$ adb push build/Ninja-ReleaseAssert/swift-linux-x86_64/lib/swift/android/libswiftCore.so /data/local/tmp
$ adb push build/Ninja-ReleaseAssert/swift-linux-x86_64/lib/swift/android/libswiftGlibc.so /data/local/tmp
$ adb push build/Ninja-ReleaseAssert/swift-linux-x86_64/lib/swift/android/libswiftSwiftOnoneSupport.so /data/local/tmp
$ adb push build/Ninja-ReleaseAssert/swift-linux-x86_64/lib/swift/android/libswiftRemoteMirror.so /data/local/tmp
$ adb push build/Ninja-ReleaseAssert/swift-linux-x86_64/lib/swift/android/libswiftSwiftExperimental.so /data/local/tmp
```

另外，你也需要复制Android NDK的libc++:

```

$ adb push ~/android-ndk-r10e/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/libc++_shared.so /data/local/tmp
```

最后，你需要将`hello`这个可编译包复制过去：

```

$ adb push hello /data/local/tmp
```

### 运行Hello World

在将所有的依赖项与可执行程序复制到了Android系统中之后，可以使用`adb shell`命令来执行`hello`这个可执行程序：

```

$ adb shell LD_LIBRARY_PATH=/data/local/tmp hello
```

那么将得到如下的结果：

```

Hello, Android
```





































