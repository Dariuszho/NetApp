_Basic command to work on NetApp CLI_

_Please run carefully each command_

_To run those commands, need connect to NetApp's CLI with high privileges_

_Seek for help if not familiar with a command_ 

[ONTAP Commands](https://docs.netapp.com/us-en/ontap-cli/index.html)

#### vserver cifs share properties
```bash
vserver cifs share properties -vserver <vserver_name> -share-name <share_name>  
```
[vserver cifs share](https://docs.netapp.com/us-en/ontap-cli//vserver-cifs-share-show.html#description)

#### get addtional info about event
```bash
event catalog show -message-name <event_name>
```
[event catalog show](https://docs.netapp.com/us-en/ontap-cli//event-catalog-show.html)

#### remove lun clone
```bash
lun mapping show -vserver <vserver_name> -path <path to lun>

lun offline -vserver <vserver_name> -path <path to lun>

lun delete -vserver <vserver_name> -path <path to lun>
```
[lun delete](https://docs.netapp.com/us-en/ontap-cli//lun-delete.html)

