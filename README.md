PostRemoteLog
=============

* Author: Samuel G. D. Williams (<http://www.oriontransfer.co.nz>)
* Copyright (C) 2009, 2011 Samuel G. D. Williams.
* Released under the MIT license.

PostRemoteLog provides several command line tools for sending packets of log data to 
a remote server. By default it collects a variety of statistics about the machine when
it is run (e.g. uptime, hostname). It features a flexible plugin architecture for message
transportation (including XMLRPC, Growl, SMTP), and comes with a basic XMLRPC server.

PostRemoteLog is primarily useful for gathering statistics over a large number of
machines. For example, it can be used as part of login and logout scripts to record
the number of active users at a given time.

Another typical usage scenario is for recording faults. For example, [Quota Check][2]
can hook into PostRemoteLog to send a notification when a user bypasses the low quota
warning.

PostRemoteLog is controlled by a single configuration file, which can be specified using
the -c option. The configuration file specifies what transport methods to use and several
other useful configuration parameters.

For examples and documentation please see the main [project page][1].

[1]: http://www.oriontransfer.co.nz/gems/post_remote_log
[2]: http://www.oriontransfer.co.nz/software/quota-check

License
-------

Copyright (c) 2010, 2011 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
