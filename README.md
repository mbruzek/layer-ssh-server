# SSH Server

This charm delivers a system with the openssh-server installed running on a 
specified port.

# Usage

Deploy this charm:  

```
juju deploy ssh-server
```

Configure the port you would like the sshd service to listen on.

```
juju set-config ssh-server port=3128
```

Now expose the charm to the outside world:

```
juju expose ssh-server
```

You can then test this is working by:  

```
ssh ubuntu@<ip-address> -p 3128
```

One could open an ssh tunnel to this server on a client:

```
ssh -D 1984 ubuntu@<ip-address> -p 3128
```

This works by allocating a socket to listen on port 1984 on the client computer.
Whenever a connection is made to this port the connection is forwarded over the
secure channel, and the application protocol is used to determine where to 
connect from the remote machine.

And from there configure the client's system proxy to localhost:1984 to route
all the traffic of that system to the deployed server. You know ... if that was
something you were interested in doing.

# Configuration

This charm only allows you to set the port that the sshd will listen on.

**port** - The port number to configure the sshd service on this system. The 
default port is 3128 a common proxy port.


## OpenSSH

  - The [OpenSSH project website](http://www.openssh.com/).
  - You can [report bugs](http://www.openssh.com/report.html) for the project
