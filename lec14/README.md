# Working with Remote Hosts

## Overview

1. [Review of `ssh`](#review-of-ssh)
2. [Making `ssh` convenient](#making-ssh-convenient)
3. [Terminal multiplexing with `tmux`](#terminal-multiplexing-with-tmux)
4. [Reminder about working Remotely](#reminder-about-working-remotely)

## Review of `ssh`

### Reminder from the slides: Terminology

- The server you are logging into is called the `remote` (host).
- The user (you) are referred to as the `client`.

### Reminder from the slides: `S`ecure `sh`ell

----------------------------------------------------------------------------------------

`ssh [opts] <username>@remote.host`

- `username` is the username on the _remote_ host.
- `remote.host` is the url of the server you want to log into.
- IP Address: `128.253.141.34`
- Symbolic name: `csug03.csuglab.cornell.edu`
- Use `-l` to specify username (no need for `@` anymore).
- `-p <port>`: connect to a specific port (may be necessary depending on the server).
- Can forward graphical _programs_ (NOT the entire screen):
- Enable `X11` forwarding with `-X`.
- Enable "trusted" `X11` forwarding with `-Y` (actually less secure, only use if needed).

----------------------------------------------------------------------------------------

**Example**: my `<NetID>` is `sjm324`, which is also my username on CSUG.  So right now,
in order to login I do

```bash
$ ssh sjm324@csug03.csuglab.cornell.edu
sjm324@csug03.csuglab.cornell.edu's password:
Last login: Thu Mar 30 11:07:36 2017 from perceval.coecis.cornell.edu

Cornell University Computer Science Undergraduate Teaching Computer

Only authorized users may access this system. Users must abide by
all applicable Cornell laws, policies, and regulations found in the
Responsible Use of Information Technology Resources Policy at:

http://www.dfa.cornell.edu/cms/treasurer/policyoffice/policies/volumes/informationtech/upload/vol5_1.pdf

=== Support Information ===

E-mail: itcoecis-help@cornell.edu
Web Site: http://help.coecis.cornell.edu/

=== Software information ===

* MATLAB R2012a is installed in /usr/local/MATLAB
* Python 2.7 is installed in /usr/local/cc-python27
sjm324@en-cs-uglab03:~>
```

Noting that the `Last login: ...` line is going to be different every time, and you will
have a very different looking prompt (the `sjm324@en-cs-uglab03:~>` part) when you login
for the first time.  See the
[reminder about working remotely](#reminder-about-working-remotely).


----------------------------------------------------------------------------------------

### What is `CSUG` Actually Like?

There is a shared filesystem that is synced between 10 redundant nodes.  In this
configuration, the files you make on `csug01` will be available when you login to
`csug04`, as well as `csug09`.  The valid hosts are `csug{01..10}` (remember the curly
braces make a range, paste this in your terminal `echo csug{01..10}`).

What this means is that you as the _client_ can login to any one of these directly.

<!-- Make your own graph: https://gist.github.com/svenevs/ce05761128e240e27883e3372ccd4ecd -->
<!-- This is the original graph
digraph G {
    client -> csug01 [color=cornflowerblue, style=bold, label="ssh"];
    client -> csug02 [color=gray44,  style=bold, label="ssh"];
    client -> "..."  [color=black, style=dotted];
    client -> csug09 [color=darkolivegreen4, style=bold, label="ssh"];
    client -> csug10 [color=blueviolet,  style=bold, label="ssh"];
    csug01 -> "shared filesystem" [dir=back];
    csug02 -> "shared filesystem" [dir=back];
    "..."  -> "shared filesystem" [dir=back, style=dotted];
    csug09 -> "shared filesystem" [dir=back];
    csug10 -> "shared filesystem" [dir=back];
}
-->
<p align="center">
    <img alt="Your git Graph" src='https://g.gravizo.com/svg?digraph%20G%20%7B%0A%20%20%20%20client%20-%3E%20csug01%20%5Bcolor%3Dcornflowerblue%2C%20style%3Dbold%2C%20label%3D%22ssh%22%5D%3B%0A%20%20%20%20client%20-%3E%20csug02%20%5Bcolor%3Dgray44%2C%20%20style%3Dbold%2C%20label%3D%22ssh%22%5D%3B%0A%20%20%20%20client%20-%3E%20%22...%22%20%20%5Bcolor%3Dblack%2C%20style%3Ddotted%5D%3B%0A%20%20%20%20client%20-%3E%20csug09%20%5Bcolor%3Ddarkolivegreen4%2C%20style%3Dbold%2C%20label%3D%22ssh%22%5D%3B%0A%20%20%20%20client%20-%3E%20csug10%20%5Bcolor%3Dblueviolet%2C%20%20style%3Dbold%2C%20label%3D%22ssh%22%5D%3B%0A%20%20%20%20csug01%20-%3E%20%22shared%20filesystem%22%20%5Bdir%3Dback%5D%3B%0A%20%20%20%20csug02%20-%3E%20%22shared%20filesystem%22%20%5Bdir%3Dback%5D%3B%0A%20%20%20%20%22...%22%20%20-%3E%20%22shared%20filesystem%22%20%5Bdir%3Dback%2C%20style%3Ddotted%5D%3B%0A%20%20%20%20csug09%20-%3E%20%22shared%20filesystem%22%20%5Bdir%3Dback%5D%3B%0A%20%20%20%20csug10%20-%3E%20%22shared%20filesystem%22%20%5Bdir%3Dback%5D%3B%0A%7D'>
</p>

Pretty cool!  If you followed the blue line by using `ssh` to login to `csug01`, you
would have access to the same files you would if you had followed the green line to
login to `csug09`.  I used different colors here only to make it very clear that you do
not log into _all_ of the servers at the same time.  If you logged into `csug01`, you
are only on that server.  It just turns out that in this particular scenario, all of
them are the same filesystem.

**Pro-Tip**: they have it setup this way so that "load balancing" can be performed.
If everybody is logged into `csug01`, and you are the only person logged into `csug09`,
you will have much faster response times.  So if one of the servers is runing slow,
logout and try a different one.

## Making `ssh` convenient

Making `ssh` convenient comes in two important forms:

1. Not needing to type your password every time, and
2. Not needing to type your username and full address of the server.

These are accomplished by using _ssh keys_, and setting up your _ssh config_ file,
respectively.

### Passwordless Login Using `ssh` Keys

You will be creating two items in this:

1. A **public** key you copy to any cluster / server you are working with
    - Generated with a `.pub` file name.
2. A **private** key that you should never share with anybody. Ever.
    - Generated with a `_rsa` postfix to the name of your key by default.

The steps are simple enough:

1. Generate your SSH key (if you do not have one).  Follow the instructions in
   [this tutorial](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).
    - For the following steps, I assume you generated the files
        - The public key 'id': `~/.ssh/id_rsa.pub`
        - The private key 'id': `~/.ssh/id_rsa`
    - If you entered something else, change the commands below accordingly.
2. Add the newly generated SSH key to your it to your keychain:

   ```bash
   # Adds the key to your ssh keyring
   $ ssh-add ~/.ssh/id_rsa
   ```

   Note that we are adding the **private** key to our local ssh keyring, not
   the public key.
3. We need to copy the public component of the key to the host.  The directions
   below are inlined from [here](http://www.linuxproblem.org/art_9.html), replace
   all instances of `<NetID>` with your NetID.

   ```bash
   # Create the ~/.ssh directory on the remote
   # IMPORTANT: set valid permissions (7 for you, 0 for everybody else) using chmod
   $ ssh <NetID>@csug03.csuglab.cornell.edu 'mkdir -p .ssh; chmod 700 .ssh'
   # Copy the public part of the key from the client to the host
   $ cat ~/.ssh/id_rsa.pub | ssh <NetID>@csug03.csuglab.cornell.edu 'cat >> .ssh/authorized_keys'
   ```

   At this point, you have now registered your SSH key with CSUG.  You can now
   use passwordless login:

   ```bash
   $ ssh <NetID>@csug03.csuglab.cornell.edu
   ```

   **Still Asking for a Password?** This is probably because your `ssh` agent is not
   running, either you skipped some steps or it stopped somehow.

   ```bash
   # start the ssh-agent
   $ eval $(ssh-agent -s)

   # make sure it is using your key
   # note there is no .pub extension, this is the actual key
   $ ssh-add ~/.ssh/id_rsa

   ```

### The `ssh` config File

Typing the entire host name the entire time is tedious.  We will setup a config file on
the _client_ (your computer).

```bash
# This should already exist if you did the above
$ mkdir -p ~/.ssh

# Create the file if it does not exist
$ touch ~/.ssh/config
```

Now edit it with your favorite text editor to include

```
Host csug03
Hostname csug03.csuglab.cornell.edu
User <NetID>
ForwardAgent yes
```

Breakdown:

- `Host`: what you want to type each time, `ssh Host`
- `Hostname`: what `ssh` will actually use when you say `ssh Host`
- `User`: your username on the _remote_ server
- `ForwardAgent`: use the `ssh` keys we setup

**Pro-Tip**: this was only an _alias_ for us to be able to `ssh` into `csug03`.  You may
as well setup the same information for `csug{01..10}`.  Just replace `csug03` with the
right thing on the first two lines for each one.

With all that, you should now be able to just execute

```bash
$ ssh csug03
```

and login to the CSUG servers.  Every now and then you may be asked to enter the
password for your actual SSH key, but this will not be that frequent.

### The Last Step

Make sure your local `.ssh` has the appropriate permissions.  These files are
fundamentally important.  If somebody else can get your file...then they can also login
to CSUG under your name **without needing your password**.  You have been warned.

```bash
$ chmod -R 700 ~/.ssh
```

## Terminal multiplexing with `tmux`

Terminal multiplexing is fantastically convenient.  In terms of logging into a remote
host, what it means is

1. You log in, and start a `tmux` session.
2. You `tmux detach`, it stays running but you can logout.
3. At some time later you want to continue your work.  You `ssh` back in and rejoin the
   still running session using `tmux attach`.

It will definitely take some getting used to, but I promise it is worth the effort.
I defer to Daniel Miessler's excellent tutorial

> ### [A `tmux` Primer](https://danielmiessler.com/study/tmux/#gs.R_UauPQ)

Included in this demo is [Sean Bell's excellent `.tmux.conf`][sean], which is the "dotfile"
associated with `tmux` (like the `.ssh/config` is to `ssh`, and `.bashrc` is to `bash`).

[sean]: https://github.com/seanbell/term-tools/blob/master/config/tmux.conf

I have changed it so that it uses `bash`, and one other minor difference that I'll let
you figure out on your own if you actually care.

**Warning**: the `tmux` control sequence in the `.tmux.conf` here is **NOT** standard.
The tutorial linked above, as well as everywhere else, use `<ctrl>+B` (the default).
Sean changed his to be `<ctrl>+A`, since `<ctrl>+B` conflicts with some of his `vim`
configurations.  Delete the relevant lines in the `.tmux.conf` file here.

**Note**: this `tmux` configuration file requires `tmux 2.2` or higher, which is not
what is available on CSUG.  I will not show you how to get `tmux 2.2` on CSUG, but
the easiest way is to actually just use
[`spack`](http://spack.readthedocs.io/en/latest/index.html).  Which is by no means an
easy solution.

Why won't I show you?  Because I'm pretty sure CSUG is setup to `kill` your `tmux`
server after a certain amount of time.

### Getting the `.tmux.conf`

If you cloned this repository:

```bash
$ cp /path/to/lecture-demos/lec14/.tmux.conf ~/.tmux.conf
```

The next time you launch `tmux` it will use this file.  Alternatively,

```
# go to your home directory
$ cd ~

# download the version using GitHub's raw hosting
# that's a capital 'oh'.  or just use `wget` instead of `curl`
$ curl -O https://raw.githubusercontent.com/cs2043-sp17/lecture-demos/master/lec14/.tmux.conf
```

## Reminder About Working Remotely

If you have been following along up until here, then you have `ssh` keys setup and
perhaps started playing around with `tmux`.  However, prior to this demo, we have talked
a lot about what actually goes into configuring your development environment.  The short
version: **all of the configurations you have done on your local machine mean nothing**.

It makes sense: you are logging into a completely different computer!  I defer to the
[lecture07 demo](../lec07) for a reminder of what goes where.

**Make sure you protect your `ssh` keys, it's as simple as [one command](#the-last-step)**.
