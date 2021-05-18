[![build](https://github.com/LolzDEV/linux_system_info/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/LolzDEV/linux_system_info/actions/workflows/build.yml)
[![likes](https://badges.bar/linux_sytem_info/likes)](https://pub.dev/packages/linux_system_info/score)
[![popularity](https://badges.bar/linux_system_info/popularity)](https://pub.dev/packages/linux_system_info/score)
[![pub points](https://badges.bar/linux_system_info/pub%20points)]

## Linux System Info

A library for getting linux system information

## Usage

A simple usage example:

```dart
import 'package:linux_system_info/linux_system_info.dart';

void main() {

  //CPU

  var cpu_usage = CpuInfo.getCpuUsagePercentage(); // This returns cpu load in percentage; e.g. 2

  var cpu0_usage = CpuInfo.getProcessors()[0].getCpuUsagePercentage(); // This returns the cpu0 load in percentage (in case of multicore cpus); e.g. 2

  var cpu0_MHz = CpuInfo.getProcessors()[0].cpu_mhz; // You can also get a lot of information about the cpu cores; e.g. 3600

  //MEMORY

  var total_mem = MemInfo().mem_total_gb; // This returns the amount of RAM in GB (you can also get it in kb or mb); e.g. 16

  var total_swap = MemInfo().swap_total_gb; // This returns the amount of SWAP in GB (you can also get it in kb or mb) e.g. 2

  //SYSTEM

  var kernel_name = SystemInfo().kernel_name; // This returns the kernel name; e.g. 'Linux'

  var kernel_version = SystemInfo().kernel_version; // This returns the kernel version; e.g. '5.11.0-16-generic'

  var os_name = SystemInfo().os_name; // This returns the os name; e.g. 'Ubuntu'

  var os_version = SystemInfo().os_version; // This returns the os version; e.g. '21.04'

  var os_release = SystemInfo().os_release; // This value is a Map containing a parsed version of /etc/os-release

}

```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/LolzDEV/linux_system_info/issues
