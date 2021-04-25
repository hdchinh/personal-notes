---
title: "Linux Process Type"
date: 2020-05-13
tags: ["NOTES"]
label: "#til"
---

> In Linux, these processes are divided into 3 types of processes: Interactive, Batch and Daemon.

The processes which are run by a user at the command line are called **Interactive processes**.

The processes which are not associated with the command line and are presented from a queue of processes, which are also most convenient for recurring tasks during the time when the system usage is low is called **the batch processes**.

The process which is identified by the system and whose PID is always ‘init’, is called as **Daemons**. The ‘init’ is a process which always gets started first at the time when a Linux computer is turned on and it remains on that system until the computer is turned off.

The Processes due to which Daemons get initiated are forking, making a parent process die when the child process starts performing their normal functions.

[1][https://www.quora.com/What-is-a-daemon-process-in-Linux](https://www.quora.com/What-is-a-daemon-process-in-Linux)
