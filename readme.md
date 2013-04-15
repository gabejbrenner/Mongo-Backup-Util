##Setup

Clone the repository:
Or if you wish to use [RVM](rvm.io) first install [curl](http://curl.haxx.se/):

        git clone https://github.com/gabejbrenner/Mongo-Backup-Util.git

Add your database names, your host name, your ssh keyname and the directory you wish it to output to to config/config.yml

NOTE: if you wish to use this utility with [Cron](http://en.wikipedia.org/wiki/Cron) or another similar scheduling program with no keyring access, it is important that you generate an ssh key without a passphrase. This can be done with the following code:

        ssh-keygen -f ~/.ssh/id_rsa.keyname
        ssh-copy-id -f .ssh/id_rsa.keyname

And add it to your host with this code:

        ssh-copy-id -f .ssh/id_rsa.keyname user@hostname.com

To schedule in [Cron](http://en.wikipedia.org/wiki/Cron) or another similar scheduling program, use the absolute path to server_db_backup.sh, e.g.

        0 0 * * * bash -l /home/user/mongo-backup-util/server_db_backup.sh

##Dependencies

###Ruby:

You can install from default package manager with:

        sudo apt-get install ruby

Or if you wish to use [RVM](rvm.io) first install [curl](http://curl.haxx.se/):

        sudo apt-get install curl

Then install [RVM](rvm.io):

        \curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby

###SSH:

Install with:

        sudo apt-get install ssh