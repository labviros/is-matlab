is
===================

Easy to use IoT messaging middleware matlab implementation. 

Dependencies
-----------------

The messaging layer is implemented using the the 
[amqp 0.9.1](https://www.rabbitmq.com/specification.html) protocol, 
requiring a broker to work. We recommend using [RabbitMQ](https://www.rabbitmq.com/).

The broker can be easily instantiated with [Docker](https://www.docker.com/) with the following command:
```c++
docker run -d -m 512M -p 15672:15672 -p 5672:5672 picoreti/rabbitmq:latest
```
To install docker run: 
```shell
curl -sSL https://get.docker.com/ | sh
```

Using the library
-----------------

This is not a native matlab implementation of the library, instead we use the java implementation
inside of matlab. Therefore the [jar](https://github.com/labviros/is-java/blob/master/out/artifacts/is_jar/is.jar) 
file needs to be imported in order to use the library.
This can be achieved by running:

```shell
javaaddpath(PATH_TO_JAR);
javaaddpath('./is.jar');
```

Messages and Serialization
----------

Currently messages are serialized/deserialized according to the [MessagePack](http://msgpack.org/) 
binary format. The **org.msgpack.core.MessagePack** package can be used to serialized/deserialized messages.
[Examples](https://github.com/labviros/is-java/tree/master/src/main/java/com/labviros/is/msgs). 


Subscribe Example
------------------

```matlab
%  Creates a connection to the broker running on localhost at port 5672, 
% with credentials guest:guest (username:password respectively).
connection = com.labviros.is.Connection('amqp://guest:guest@192.168.1.110:5672');

%  Subscribe to the topic 'ptgrey.0.frame' from the 'data' exchange returning a queue
% that we can use to consume the messages.
queue = connection.subscribe('data', 'ptgrey.0.frame'); 

% Wait forever waiting a message from 'ptgrey.0.frame'
message = queue.take();

% Here we need to unpack the message in order to use it. We know that this topic returns 
% a message of type CompressedImage, so:

compressedImage = com.labviros.is.msgs.camera.CompressedImage(message); % But dont use this for this type in particular

% CompressedImage is basically a binary buffer of an image in a certain format: png, etc.
% We would like to have it as a matlab matrix. Therefore a helper is provided:

image = imunpack(message); % Unpack message to image matrix
```
