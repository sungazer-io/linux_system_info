import 'package:linux_system_info/linux_system_info.dart';

void main() async {

  print((MemInfo().mem_free_gb * 100) / MemInfo().mem_total_gb);

}
