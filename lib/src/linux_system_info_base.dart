import 'dart:io';
import 'package:tuple/tuple.dart';

/// Class for handling general system information
class SystemInfo {
  /// Current kernel name, e.g.: `Linux`
  String kernel_name = '';

  /// Current kernel version, e.g.: `5.11.0-16-generic`
  String kernel_version = '';

  /// Current os name, e.g.: `Ubuntu`
  String os_name = '';

  /// Current os version, e.g.: `21.04`
  String os_version = '';

  /// A parsing of `/etc/os-release` containing information like the distro codename and homepage
  Map<String, String> os_release = <String, String>{};

  /// Empty constructor, this loads all the information from `/proc/version` and from `/etc/os-release`
  SystemInfo() {
    var content = File('/proc/version').readAsStringSync();
    kernel_name = content.split(' ')[0];
    kernel_version = content.split(' ')[2];
    var lines = File('/etc/os-release').readAsLinesSync();
    os_release = <String, String>{};
    for (var e in lines) {
      var data = e.split('=');
      os_release[data[0]] = data[1].replaceAll('\"', '');
    }

    os_name = os_release['NAME'] ?? '';
    os_version = os_release['VERSION_ID'] ?? '';
  }
}

/// Class containing CPU core data
class Cpu {
  /// Core number
  int processor = 0;

  /// CPU vendor identifier
  String vendor_id = '';

  /// CPU family
  int cpu_family = -1;

  /// CPU model
  int model = -1;

  /// CPU model name
  String model_name = '';

  /// CPU stepping
  int stepping = -1;

  /// CPU microcode
  int microcode = -1;

  /// CPU MHz
  double cpu_mhz = -1.0;

  /// CPU cache size
  String cache_size = '';

  /// CPU physical id
  int physical_id = -1;

  /// CPU siblings
  int siblings = -1;

  /// CPU core identifier
  int core_id = -1;

  /// Total amount of cores
  int cpu_cores = -1;

  /// CPU apicid
  int apicid = -1;

  /// CPU initial apicid
  int initial_apicid = -1;

  /// If cpu has an FPU (Floating point unit)
  bool fpu = false;

  /// If FPU has an exception
  bool fpu_exception = false;

  /// Cpuid level
  int cpuid_level = -1;
  bool wp = false;

  /// CPU's flags
  List<String> flags = [];

  /// CPU bogomips
  double bogomips = -1.0;

  /// CPU clflush's size
  int clflush_size = -1;

  /// CPU cache alignment
  int cache_alignment = -1;
  Tuple2<String, String> address_sizes = Tuple2<String, String>('', '');

  /// Constructor for creating a [Cpu] with data in it
  Cpu.fromData(
      this.processor,
      this.vendor_id,
      this.cpu_family,
      this.model,
      this.model_name,
      this.stepping,
      this.microcode,
      this.cpu_mhz,
      this.cache_size,
      this.physical_id,
      this.siblings,
      this.core_id,
      this.cpu_cores,
      this.apicid,
      this.initial_apicid,
      this.fpu,
      this.fpu_exception,
      this.cpuid_level,
      this.wp,
      this.flags,
      this.bogomips,
      this.clflush_size,
      this.cache_alignment,
      this.address_sizes);

  /// Empty constructor, creates a [Cpu] object with default values in it
  Cpu();

  /// Get current core load
  List<int> load() {
    var f = File('/proc/stat');
    var lines = f.readAsLinesSync();

    var loads = lines[processor + 1].split(' ');

    loads.removeAt(0);

    var total = loads
        .map((String token) => int.parse(token))
        .toList()
        .reduce((int a, int b) => a + b);

    var idle = int.parse(loads[3]);

    return [idle, total];
  }

  /// Get a [Stream] for handling the core usage in percentage as a [double]
  Stream<double> getCpuUsagePercentage() async* {
    var idleTotalPrev = <int>[0, 0];

    while (true) {
      var idleTotal = load();
      var dTotal = idleTotal[0] - idleTotalPrev[0];
      var dLoad = idleTotal[1] - idleTotalPrev[1];
      idleTotalPrev = idleTotal;

      var percent = 100.0 * (1.0 - dTotal / dLoad);
      yield percent;

      sleep(Duration(seconds: 1));
    }
  }
}

/// Class memory information
class MemInfo {
  /// Total RAM amount in Kb
  int mem_total = 0;

  /// Total RAM amount in Mb
  int mem_total_mb = 0;

  /// Total RAM amount in Gb
  int mem_total_gb = 0;

  /// Free RAM amount in Kb
  int mem_free = 0;

  /// Free RAM amount in Mb
  int mem_free_mb = 0;

  /// Free RAM amount in Gb
  int mem_free_gb = 0;

  /// Total Swap amount in Kb
  int swap_total = 0;

  /// Total Swap amount in Mb
  int swap_total_mb = 0;

  /// Total Swap amount in Gb
  int swap_total_gb = 0;

  /// Free Swap amount in Kb
  int swap_free = 0;

  /// Free Swap amount in Mb
  int swap_free_mb = 0;

  /// Free Swap amount in Gb
  int swap_free_gb = 0;

  /// Empty constructor, this loads all the information from `/proc/meminfo`
  MemInfo() {
    var lines = File('/proc/meminfo').readAsLinesSync();

    for (var e in lines) {
      var data = e.split(':');
      if (data.length == 2) {
        data[0] = data[0].trim();
        switch (data[0]) {
          case 'MemTotal':
            {
              data[1] = data[1].trim().substring(0, data[1].trim().length - 3);
              mem_total = int.parse(data[1]);
              mem_total_mb = (mem_total / 1024).round();
              mem_total_gb = (mem_total_mb / 1024).round();
            }
            break;
          case 'MemFree':
            {
              data[1] = data[1].trim().substring(0, data[1].trim().length - 3);
              mem_free = int.parse(data[1]);
              mem_free_mb = (mem_free / 1024).round();
              mem_free_gb = (mem_free_mb / 1024).round();
            }
            break;
          case 'SwapTotal':
            {
              data[1] = data[1].trim().substring(0, data[1].trim().length - 3);
              swap_total = int.parse(data[1]);
              swap_total_mb = (swap_total / 1024).round();
              swap_total_gb = (swap_total_mb / 1024).round();
            }
            break;
          case 'SwapFree':
            {
              data[1] = data[1].trim().substring(0, data[1].trim().length - 3);
              swap_free = int.parse(data[1]);
              swap_free_mb = (swap_free / 1024).round();
              swap_free_gb = (swap_free_mb / 1024).round();
            }
            break;
        }
      }
    }
  }
}

/// Class containing CPU information
class CpuInfo {
  /// Get a [List] containing all cpu's cores in a [Cpu] class
  static List<Cpu> getProcessors() {
    var cpus = <Cpu>[];
    var curCpu = 0;
    var currentCpu = Cpu();
    var lines = File('/proc/cpuinfo').readAsLinesSync();
    for (var e in lines) {
      var data = e.split(':');

      if (data.isNotEmpty) {
        data[0] = data[0].trim();
        if (data[0] == 'processor' && curCpu > 0) {
          cpus.add(currentCpu);
          currentCpu = Cpu();
          currentCpu.processor = int.parse(data[1]);
          curCpu += 1;
        }

        switch (data[0]) {
          case 'vendor_id':
            {
              currentCpu.vendor_id = data[1];
            }
            break;
          case 'cpu family':
            {
              currentCpu.cpu_family = int.parse(data[1]);
            }
            break;
          case 'model':
            {
              currentCpu.model = int.parse(data[1]);
            }
            break;
          case 'model name':
            {
              currentCpu.model_name = data[1];
            }
            break;
          case 'stepping':
            {
              currentCpu.stepping = int.parse(data[1]);
            }
            break;
          case 'microcode':
            {
              currentCpu.microcode = int.parse(data[1]);
            }
            break;
          case 'cpu MHz':
            {
              currentCpu.cpu_mhz = double.parse(data[1]);
            }
            break;
          case 'cache size':
            {
              currentCpu.cache_size = data[1];
            }
            break;
          case 'physical id':
            {
              currentCpu.physical_id = int.parse(data[1]);
            }
            break;
          case 'siblings':
            {
              currentCpu.siblings = int.parse(data[1]);
            }
            break;
          case 'core id':
            {
              currentCpu.core_id = int.parse(data[1]);
            }
            break;
          case 'cpu cores':
            {
              currentCpu.cpu_cores = int.parse(data[1]);
            }
            break;
          case 'apicid':
            {
              currentCpu.apicid = int.parse(data[1]);
            }
            break;
          case 'initial apicid':
            {
              currentCpu.initial_apicid = int.parse(data[1]);
            }
            break;
          case 'fpu':
            {
              currentCpu.fpu = data[1] == 'yes' ? true : false;
            }
            break;
          case 'fpu_exception':
            {
              currentCpu.fpu_exception = data[1] == 'yes' ? true : false;
            }
            break;
          case 'cpuid level':
            {
              currentCpu.cpuid_level = int.parse(data[1]);
            }
            break;
          case 'wp':
            {
              currentCpu.wp = data[1] == 'yes' ? true : false;
            }
            break;
          case 'flags':
            {
              currentCpu.flags = data[1].split(' ');
            }
            break;
          case 'bogomips':
            {
              currentCpu.bogomips = double.parse(data[1]);
            }
            break;
          case 'clflush size':
            {
              currentCpu.clflush_size = int.parse(data[1]);
            }
            break;
          case 'cache_alignment':
            {
              currentCpu.cache_alignment = int.parse(data[1]);
            }
            break;
          case 'address sizes':
            {
              currentCpu.address_sizes =
                  Tuple2(data[1].split(',')[0], data[1].split(',')[1]);
            }
            break;
        }

        if (curCpu == 0) {
          curCpu += 1;
        }
      }
    }
    return cpus;
  }

  /// Get total cpu load
  static List<int> load() {
    var f = File('/proc/stat');
    var lines = f.readAsLinesSync();

    var loads = lines[0]
        .substring('cpu  '.length)
        .split(' ')
        .map((String token) => int.parse(token))
        .toList();

    var idle = loads[3];
    var total = loads.reduce((int a, int b) => a + b);

    return [idle, total];
  }

  /// Get a [Stream] for handling the total cpu usage in percentage as a [double]
  static Stream<double> getCpuUsagePercentage() async* {
    var idleTotalPrev = <int>[0, 0];

    while (true) {
      var idleTotal = load();
      var dTotal = idleTotal[0] - idleTotalPrev[0];
      var dLoad = idleTotal[1] - idleTotalPrev[1];
      idleTotalPrev = idleTotal;

      var percent = 100.0 * (1.0 - dTotal / dLoad);
      yield percent;

      sleep(Duration(seconds: 1));
    }
  }
}
