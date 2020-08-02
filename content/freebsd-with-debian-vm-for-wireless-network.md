Title: FreeBSD with Debian vm for wireless network
Slug: freebsd-with-debian-vm-for-wireless-network
Date: 2020-08-02 16:22:58
Tags: freebsd, bhyve, vm, debian, wireless
Category: Blog

New hardware doesn't always have working drivers in [FreeBSD](https://www.freebsd.org/). The developers do a great job, but there are not enough of them. 
On the other side, it seems like hardware companies pour out an endless stream of new hardware every month.

I wanted to see if I could use a [Debian](https://www.debian.org/) virtual machine (vm) as a guest on the FreeBSD host to fix the "unsupported wifi in FreeBSD" problem.
FreeBSD has great support for running virtual machines through [bhyve](https://bhyve.org/). And almost all newer machines has the necessary hardware support
for running virtual machines.

So I bought a cheap laptop on a summer outlet sale from one of the online shops here in Norway. For NOK 1997.- (which is about USD 220.- at the current exchange
 rate) I got an "as new, in original box" [Lenovo ideapad 530S-14ARR](https://psref.lenovo.com/Detail/Lenovo%20Laptops/ideapad_530S_14_AMD?M=81H10000MX) with AMD Ryzen 3 2200U cpu,
4 GB memory and 128 GB SSD. The integrated graphics is AMD Radeon Vega 3, I was unsure if it was supported but it didn't matter for this experiment. I was pretty sure the wireless
adapter / chipset was not supported, even if the description was a bit vague "11ac, 1x1, Wi-Fi + Bluetooth combo adapter" - many newer laptops have Broadcom wireless and that currently 
has limited support in FreeBSD. Qualcomm support is almost non-existent.

There is one initial hurdle to overcome when installing and configuring FreeBSD (and Debian too) today: most install methods are set up for a network install. It is possible to install either
without a working network, but it is just harder (I should note that the install itself isn't the hardest part, but adding packages you need after the install is finished is). So I 
used a usb-hub-with-ethernet-port dongle when I did the initial install, for FreeBSD and packages, and also for the Debian vm and packages. In FreeBSD this device shows up as
```
root@kg-pod530:~ # usbconfig -d ugen0.2
ugen0.2: <GenesysLogic USB2.0 Hub> at usbus0, cfg=0 md=HOST spd=HIGH (480Mbps) pwr=SAVE (100mA)
root@kg-pod530:~ # usbconfig -d ugen0.3
ugen0.3: <Realtek USB 10/100 LAN> at usbus0, cfg=0 md=HOST spd=HIGH (480Mbps) pwr=ON (100mA)
root@kg-pod530:~ # usbconfig -d ugen0.4
ugen0.4: <vendor 0x0cf3 product 0xe500> at usbus0, cfg=0 md=HOST spd=FULL (12Mbps) pwr=ON (100mA)
root@kg-pod530:~ # usbconfig -d ugen0.5
ugen0.5: <GenesysLogic USB3.0 Hub> at usbus0, cfg=0 md=HOST spd=SUPER (5.0Gbps) pwr=SAVE (0mA)
```
with usbconfig, and this is what shows in `/var/log/messges`:
```
Jul 28 22:56:05 kg-pod530 kernel: ugen0.2: <GenesysLogic USB2.0 Hub> at usbus0
Jul 28 22:56:05 kg-pod530 kernel: uhub2 on uhub1
Jul 28 22:56:05 kg-pod530 kernel: uhub2: <GenesysLogic USB2.0 Hub, class 9/0, rev 2.10/92.24, addr 1> on usbus0
Jul 28 22:56:05 kg-pod530 kernel: uhub2: MTT enabled
Jul 28 22:56:05 kg-pod530 kernel: uhub2: 4 ports with 1 removable, self powered
Jul 28 22:56:05 kg-pod530 kernel: ugen0.3: <Realtek USB 10/100 LAN> at usbus0

Jul 28 22:56:06 kg-pod530 kernel: ugen0.5: <GenesysLogic USB3.0 Hub> at usbus0
Jul 28 22:56:06 kg-pod530 kernel: uhub3 on uhub1
Jul 28 22:56:06 kg-pod530 kernel: uhub3: <GenesysLogic> on usbus0
Jul 28 22:56:07 kg-pod530 kernel: uhub3: 4 ports with 1 removable, self powered

Jul 28 22:56:07 kg-pod530 kernel: ure0 on uhub2
Jul 28 22:56:07 kg-pod530 kernel: ure0: <Realtek USB 10/100 LAN, class 0/0, rev 2.10/20.00, addr 2> on usbus0

Jul 28 22:56:07 kg-pod530 kernel: miibus0: <MII bus> on ure0
Jul 28 22:56:07 kg-pod530 kernel: rlphy0: <RTL8201E 10/100 media interface> PHY 0 on miibus0
Jul 28 22:56:07 kg-pod530 kernel: rlphy0:  10baseT, 10baseT-FDX, 100baseTX, 100baseTX-FDX, auto
Jul 28 22:56:07 kg-pod530 kernel: ue0: <USB Ethernet> on ure0
Jul 28 22:56:07 kg-pod530 kernel: ue0: Ethernet address: 00:e0:4c:36:08:f8
Jul 28 22:56:07 kg-pod530 kernel: ue0: link state changed to DOWN
Jul 28 22:56:09 kg-pod530 kernel: ue0: link state changed to UP
```

Once FreeBSD was installed, I could check what the wireless card was:
```
root@kg-pod530:~ # pciconf -lv | grep -B 3 network
ppt0@pci0:1:0:0:    class=0x028000 card=0x090117aa chip=0x0042168c rev=0x31 hdr=0x00
    vendor     = 'Qualcomm Atheros'
    device     = 'QCA9377 802.11ac Wireless Network Adapter'
    class      = network
```
so yes - currently not supported in FreeBSD. Next up was to set up a vm, I chose to install [vm-bhyve](https://github.com/churchers/vm-bhyve) for that, it makes working with bhyve 
virtual machines easier. I also wanted this vm to have access to the wireless hardware, so figure out how vm-bhyve sees it.
```
root@kg-pod530:~ # vm passthru
DEVICE     BHYVE ID     READY        DESCRIPTION
hostb0     0/0/0        No           -
none0      0/0/2        No           -
hostb1     0/1/0        No           Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
pcib1      0/1/2        No           -
pcib2      0/1/7        No           -
hostb2     0/8/0        No           Family 17h (Models 00h-1fh) PCIe Dummy Host Bridge
pcib3      0/8/1        No           -
intsmb0    0/20/0       No           FCH SMBus Controller
isab0      0/20/3       No           FCH LPC Bridge
hostb3     0/24/0       No           -
hostb4     0/24/1       No           -
hostb5     0/24/2       No           -
hostb6     0/24/3       No           -
hostb7     0/24/4       No           -
hostb8     0/24/5       No           -
hostb9     0/24/6       No           -
hostb10    0/24/7       No           -
none1      1/0/0        No           QCA9377 802.11ac Wireless Network Adapter
nvme0      2/0/0        No           -
vgapci0    3/0/0        No           Raven Ridge [Radeon Vega Series / Radeon Vega Mobile Series]
hdac0      3/0/1        No           Raven Ridge HDMI/DP Audio Controller
none2      3/0/2        No           Family 17h (Models 10h-1fh) Platform Security Processor
xhci0      3/0/3        No           -
xhci1      3/0/4        No           -
hdac1      3/0/6        No           Family 17h (Models 10h-1fh) HD Audio Controller
none3      3/0/7        No           -
```
so I want (or rather, the vm needs to have device 1/0/0). The way to configure this is to set up a `pptdevs` variable in `/boot/loader.conf`. Since I have an AMD cpu, the
`hw.vmm.amdvi.enable=1` setting is also needed. Finally you need to load the vmm kernel module. Together, it looks like this
```
root@kg-pod530:~ # cat /boot/loader.conf
hw.vmm.amdvi.enable=1
pptdevs="1/0/0"
vmm_load="YES"
```

Debian vm install is quite straight forward, but I needed to use the non-free firmware image
```
root@kg-pod530:~ # vm install gateway firmware-10.4.0-amd64-netinst.iso
root@kg-pod530:~ # vm console gateway
```

Debian vm configuration. I used [BridgeNetworkConnectionsProxyArp](https://wiki.debian.org/BridgeNetworkConnectionsProxyArp) as a guide, the only thing I needed to change (other 
than network interface names) was the systemd unit file for dhcp-helper. I changed to file to this:
```
tingo@pod530-gw:~$ cat /lib/systemd/system/dhcp-helper.service
[Unit]
Description=DHCP/BOOTP relay agent
After=network.target

[Service]
Type=forking
EnvironmentFile=/etc/default/dhcp-helper
PIDFile=/run/dhcp-helper.pid
# for some reason interface wlp0s6 is not there on first start, try restarting
Restart=on-failure
RestartSec=5
TimeoutStartSec=30
ExecStart=/usr/sbin/dhcp-helper -r /run/dhcp-helper.pid $DHCPHELPER_OPTS

[Install]
WantedBy=multi-user.target
```
before I changed it, the service would fail on boot and would need to be restarted. I just set up wpa_supplicant, rebooted the vm and it connected to the wireless network.

Other problems. I also had too restrictive rules on my firewall, so I need to fix that before the response from the DHCP server would get to the FreeBSD machine.

Final network setup on te FreeBSD side. I tried several things, but in the end, using [epair(4)](https://www.freebsd.org/cgi/man.cgi?query=epair) interfaces worked.
Currently, network configuration in `/etc/rc.conf` looks like this:
```
cloned_interfaces="bridge0 epair0"
ifconfig_bridge0="addm epair0b"
defaultroute_delay="1"
background_dhclient_epair0a="YES"
ifconfig_epair0a="DHCP"
ifconfig_epair0b="up"
```
the bridge is configured as manual in vm-bhyve, and the vm connects to it. The reason for putting dhclient in the background and minimizing the defaultroute delay is that
the FreeBSD machine will not get an ip address from the DHCP server until the vm is up and working. So better just make it boot quickly.