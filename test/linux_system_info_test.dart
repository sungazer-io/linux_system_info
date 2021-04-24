import 'package:linux_system_info/linux_system_info.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {

  test('Check returned data', () {
    var cpu0_MHz = CpuInfo.getProcessors()[0].cpu_mhz;
    expect(cpu0_MHz.runtimeType, equals(int));

    var total_mem = MemInfo().mem_total_gb;
    expect(total_mem.runtimeType, equals(int));

    var total_swap = MemInfo().swap_total_gb;
    expect(total_swap.runtimeType, equals(int));

    var kernel_name = SystemInfo().kernel_name;
    expect(kernel_name.runtimeType, equals(String));

    var kernel_version = SystemInfo().kernel_version;
    expect(kernel_version.runtimeType, equals(String));

    var os_name = SystemInfo().os_name;
    expect(os_name.runtimeType, equals(String));

    var os_version = SystemInfo().os_version;
    expect(os_version.runtimeType, equals(String));

    var os_release = SystemInfo().os_release;
    expect(os_release.runtimeType, equals(Map));

  });

}
