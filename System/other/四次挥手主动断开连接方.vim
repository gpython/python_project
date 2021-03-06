
主动断开连接方 会出现time_wait

我们有2台内部http服务（nginx）：

201：这台服务器部署的服务是account.api.91160.com，这个服务是供前端页面调用；

202：这台服务器部署的服务是hdbs.api.91160.com，    这个服务是供前端页面调用；



近期发现，这2台服务器的网络连接中，TIME_WAIT 数量差别很大，201的TIME_WAIT大概20000+，202的TIME_WAIT大概1000 ，差距20倍；2台的请求量差不多，都是以上内部调用的连接，且服务模式也没有什么差异，为什么连接数会差这么大？



后找原因：是因为这2个模块的调用程序由不同团队写的，调用方式不一样，导致一个是调用方（客户端，PHP程序）主动断开连接，一个是被调用方（服务端 201、202）主动断开连接；因TIME_WAIT 产生在主动断开连接的一方，因此导致一台服务器TIME_WAIT 数高，一台TIME_WAIT 数低；



这就有个细节，一次http请求，谁会先断开TCP连接？什么情况下客户端先断，什么情况下服务端先断？

百度后，找到原因，主要有http1.0和http1.1之间保持连接的差异以及http头中connection、content-length、Transfer-encoding等参数有关；



 以下内容转载：（http://blog.csdn.net/wangpengqi/article/details/17245349）

当然，在nginx中，对于http1.0与http1.1也是支持长连接的。什么是长连接呢？我们知道，http请求是基于TCP协议之上的，那么，当客户端在发起请求前，需要先与服务端建立TCP连接，而每一次的TCP连接是需要三次握手来确定的，如果客户端与服务端之间网络差一点，这三次交互消费的时间会比较多，而且三次交互也会带来网络流量。当然，当连接断开后，也会有四次的交互，当然对用户体验来说就不重要了。而http请求是请求应答式的，如果我们能知道每个请求头与响应体的长度，那么我们是可以在一个连接上面执行多个请求的，这就是所谓的长连接，但前提条件是我们先得确定请求头与响应体的长度。对于请求来说，如果当前请求需要有body，如POST请求，那么nginx就需要客户端在请求头中指定content-length来表明body的大小，否则返回400错误。也就是说，请求体的长度是确定的，那么响应体的长度呢？先来看看http协议中关于响应body长度的确定：
1.对于http1.0协议来说，如果响应头中有content-length头，则以content-length的长度就可以知道body的长度了，客户端在接收body时，就可以依照这个长度来接收数据，接收完后，就表示这个请求完成了。而如果没有content-length头，则客户端会一直接收数据，直到服务端主动断开连接，才表示body接收完了。
2.而对于http1.1协议来说，如果响应头中的Transfer-encoding为chunked传输，则表示body是流式输出，body会被分成多个块，每块的开始会标识出当前块的长度，此时，body不需要通过长度来指定。如果是非chunked传输，而且有content-length，则按照content-length来接收数据。否则，如果是非chunked，并且没有content-length，则客户端接收数据，直到服务端主动断开连接。

从上面，我们可以看到，除了http1.0不带content-length以及http1.1非chunked不带content-length外，body的长度是可知的。此时，当服务端在输出完body之后，会可以考虑使用长连接。能否使用长连接，也是有条件限制的。如果客户端的请求头中的connection为close，则表示客户端需要关掉长连接，如果为keep-alive，则客户端需要打开长连接，如果客户端的请求中没有connection这个头，那么根据协议，如果是http1.0，则默认为close，如果是http1.1，则默认为keep-alive。如果结果为keepalive，那么，nginx在输出完响应体后，会设置当前连接的keepalive属性，然后等待客户端下一次请求。当然，nginx不可能一直等待下去，如果客户端一直不发数据过来，岂不是一直占用这个连接？所以当nginx设置了keepalive等待下一次的请求时，同时也会设置一个最大等待时间，这个时间是通过选项keepalive_timeout来配置的，如果配置为0，则表示关掉keepalive，此时，http版本无论是1.1还是1.0，客户端的connection不管是close还是keepalive，都会强制为close。

如果服务端最后的决定是keepalive打开，那么在响应的http头里面，也会包含有connection头域，其值是”Keep-Alive”，否则就是”Close”。如果connection值为close，那么在nginx响应完数据后，会主动关掉连接。所以，对于请求量比较大的nginx来说，关掉keepalive最后会产生比较多的time-wait状态的socket。一般来说，当客户端的一次访问，需要多次访问同一个server时，打开keepalive的优势非常大，比如图片服务器，通常一个网页会包含很多个图片。打开keepalive也会大量减少time-wait的数量。



总结: (不考虑keepalive)

http1.0

带content-length，body长度可知，客户端在接收body时，就可以依据这个长度来接受数据。接受完毕后，就表示这个请求完毕了。客户端主动调用close进入四次挥手。

不带content-length ，body长度不可知，客户端一直接受数据，直到服务端主动断开



http1.1

带content-length                       body长度可知     客户端主动断开

带Transfer-encoding：chunked       body会被分成多个块，每块的开始会标识出当前块的长度，body就不需要通过content-length来指定了。但依然可以知道body的长度 客户端主动断开

不带Transfer-encoding：chunked且不带content-length        客户端接收数据，直到服务端主动断开连接。



即 ：如果能够有办法知道服务器传来的长度，都是客户端首先断开。如果不知道就一直接收数据。知道服务端断开。