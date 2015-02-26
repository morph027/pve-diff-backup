# pve-diff-backup
Proxmox VE differential backups

[created by ayufan](http://ayufan.eu/projects/proxmox-ve-differential-backups/)

## Install

``./pve-diff-backup.sh apply``

When everything went right, you’ll see:

```
Proxmox VE X.Y - differential backup support  
Kamil Trzcinski, http://ayufan.eu/, ayufan@ayufan.eu
    
PATCHED: /usr/share/pve-manager/  
PATCHED: /usr/share/perl5/PVE/

Restarting PVE API Proxy Server: pveproxy. 
Restarting PVE Daemon: pvedaemon.
```

This wrapper will also install patched version of *xdelta3*

## Uninstall

``./pve-diff-backup.sh revert``

After a while, you’ll see:

```
Proxmox VE X.Y - differential backup support  
Kamil Trzcinski, http://ayufan.eu/, ayufan@ayufan.eu  

RESTORED: /usr/share/pve-manager/
RESTORED: /usr/share/perl5/PVE/

Restarting PVE API Proxy Server: pveproxy.
Restarting PVE Daemon: pvedaemon.
```

## What about UPGRADE? (READ THIS)

This is important part. If you will ever want to upgrade your Proxmox installation (by apt-get dist-upgrade or apt-get upgrade) ALWAYS revert/uninstall patches. You will still be able to apply them afterwards.

## Is it stable?

Yes, it is. This extensions uses xdelta3 as differential backup tool, which proven to be well tested and stable. I use it for about 9 months on 4 different Proxmox based servers. No problems so far.

However, if you happen to be paranoidal about backups… You should consider running following script. The script simply tries to verify all differential backups. I recently updated the script to support new VMA archive. So now you can verify backups all supported backups.

``chmod +x pve-verify-backups``

``./pve-verify-backups <backup-dir>``

## FAQ

In case of any problems applying or reverting patches you can always simple revert back to stock. Simply reinstall modified packages:

``apt-get --reinstall install pve-manager qemu-server libpve-storage-perl``

Then you can try to reapply patches once again.

In order to remove all leftovers you have to edit /etc/pve/vzdump.cron and remove fullbackup switch from vzdump command line.

## Changelog

    v1: initial public release with support for PVE2.2 and PVE2.3 (2013-03-05)
    v2: improved kvm backup size and speed for PVE2.3 (2013-03-08)
    v3: added support for PVE3.0 (2013-06-02)
    v3': updated pve-verify-backups to support VMA archives (2013-06-06)
    v3'': updated patches to support PVE3.1 (2013-08-24)
    v3'': updated xdelta3 to 3.0.6. More info about changes: http://xdelta.org/ (2013-08-24)
    v3'': updated patches to support PVE3.2 (2014-03-15)
    v3'': added FAQ (2014-04-30)
    v3'': updated patches to support PVE3.3 (2014-09-23)
    v3'': updated patches to support PVE3.4 (2015-02-26)

### Detailed list of changes

1. pve-xdelta3:
  - repackaged from http://packages.debian.org/wheezy/xdelta3
  - added support for lzop
  - removed all python references
2. vzdump:
  - added “fullbackup” option
3. qmrestore and vzrestore:
  - added support for differential backups
4. PVE.dc.BackupEdit:
  - added controls for maxfiles and fullbackup
