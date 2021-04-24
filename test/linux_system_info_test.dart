import 'package:linux_system_info/linux_system_info.dart';

void main() {

  var cpu0_MHz = CpuInfo.getProcessors()[0].cpu_mhz;

  var total_mem = MemInfo().mem_total_gb;

  var total_swap = MemInfo().swap_total_gb;

  var kernel_name = SystemInfo().kernel_name;

  var kernel_version = SystemInfo().kernel_version;

  var os_name = SystemInfo().os_name;

  var os_version = SystemInfo().os_version;

  var os_release = SystemInfo().os_release;

  print('Tested Data: $cpu0_MHz, $total_mem, $total_swap, $kernel_name, $kernel_version, $os_name, $os_version, $os_release');

}
