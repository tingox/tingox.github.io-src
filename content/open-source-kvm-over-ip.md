Title: Open source KVM over IP
Slug: open-source-kvm-over-ip
Date: 2020-08-03 22:52:25
Tags: kvm, linux, open source
Category: Blog

[Pi-KVM](https://pikvm.org/) is a very interesting project. It allows you to build a fully functional [KVM](https://en.wikipedia.org/wiki/KVM_switch) over IP solution using cheap 
hardware and open source software. Source at Github: [pikvm/pikvm](https://github.com/pikvm/pikvm) The KVM supports virtual CD-ROM and virtual flash drive too. You can power on / off
the server via ATX power control. Wonderful, and useful too.

The requirements for the server you are comntrolling isn't too great; it must have HDMI output (for VGA use a VGA-to-HDMI converter) and use  usb keyboard and mouse. As already
mentioned in [issue 26](https://github.com/pikvm/pikvm/issues/26) it is possible to create a FPGA-based capture device, so in theory you could handle other type of console output too.
