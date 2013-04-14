#Setup

Clone the repository:

        git clone https://github.com/gabejbrenner/Mongo-Backup-Util.git

Add your database names, your host name and your ssh keyname to config/config.yml

NOTE: if you wish to use this utility with [Cron](http://en.wikipedia.org/wiki/Cron), or another similar scheduling program with no keyring access, it is important that you generate an ssh key without a passphrase. This can be done with the following code:

        ssh-keygen -f ~/.ssh/id_rsa.keyname
        ssh-copy-id -f .ssh/id_rsa.keyname

And add it to your host with this code:

        ssh-copy-id -f .ssh/id_rsa.keyname user@hostname.com

#Dependencies

##Ruby:

Install with:

        sudo apt-get install ruby

or:

        \curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby

##SSH:

Install with:

        sudo apt-get install ssh