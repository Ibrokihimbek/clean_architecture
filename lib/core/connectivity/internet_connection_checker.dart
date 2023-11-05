import 'dart:async';
import 'dart:io';

class AddressCheckResult {
  const AddressCheckResult(
    this.options, {
    required this.isSuccess,
  });

  final AddressCheckOptions options;
  final bool isSuccess;

  @override
  String toString() => 'AddressCheckResult($options, $isSuccess)';
}

class AddressCheckOptions {
  const AddressCheckOptions({
    this.address,
    this.hostname,
    this.port = InternetConnectionChecker.defaultPort,
    this.timeout = InternetConnectionChecker.defaultTimeout,
  }) : assert(
          (address != null || hostname != null) &&
              ((address != null) != (hostname != null)),
          'Either address or hostname must be provided, but not both.',
        );

  final InternetAddress? address;
  final String? hostname;
  final int port;
  final Duration timeout;

  @override
  String toString() => 'AddressCheckOptions($address, $port, $timeout)';
}

enum InternetConnectionStatus {
  connected,
  disconnected,
}

class InternetConnectionChecker {
  factory InternetConnectionChecker() => _instance;

  InternetConnectionChecker.createInstance({
    this.checkTimeout = defaultTimeout,
    this.checkInterval = defaultInterval,
    List<AddressCheckOptions>? addresses,
  }) {
    this.addresses = addresses ??
        defaultAddresses
            .map(
              (e) => AddressCheckOptions(
                address: e.address,
                hostname: e.hostname,
                port: e.port,
                timeout: checkTimeout,
              ),
            )
            .toList();

    // immediately perform an initial check so we know the last status?
    // connectionStatus.then((status) => _lastStatus = status);

    // start sending status updates to onStatusChange when there are listeners
    // (emits only if there's any change since the last status update)
    _statusController
      ..onListen = _maybeEmitStatusUpdate

      // stop sending status updates when no one is listening
      ..onCancel = () {
        _timerHandle?.cancel();
        _lastStatus = null; // reset last status
      };
  }

  /// More info on why default port is 53
  /// here:
  /// - https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
  /// - https://www.google.com/search?q=dns+server+port
  static const int defaultPort = 53;

  /// Default timeout is 10 seconds.
  ///
  /// Timeout is the number of seconds before a request is dropped
  /// and an address is considered unreachable
  static const Duration defaultTimeout = Duration(seconds: 10);

  /// Default interval is 10 seconds
  ///
  /// Interval is the time between automatic checks
  static const Duration defaultInterval = Duration(seconds: 10);

  /// | Address        | Provider   | Info                                            |
  /// |:---------------|:-----------|:------------------------------------------------|
  /// | 1.1.1.1        | CloudFlare | https://1.1.1.1                                 |
  /// | 1.0.0.1        | CloudFlare | https://1.1.1.1                                 |
  /// | 8.8.8.8        | Google     | https://developers.google.com/speed/public-dns/ |
  /// | 8.8.4.4        | Google     | https://developers.google.com/speed/public-dns/ |
  /// | 208.67.222.222 | OpenDNS    | https://use.opendns.com/                        |
  /// | 208.67.220.220 | OpenDNS    | https://use.opendns.com/                        |
  static final List<AddressCheckOptions> defaultAddresses =
      List<AddressCheckOptions>.unmodifiable(
    <AddressCheckOptions>[
      AddressCheckOptions(
        address: InternetAddress(
          '1.1.1.1', // CloudFlare
          type: InternetAddressType.IPv4,
        ),
      ),
      AddressCheckOptions(
        address: InternetAddress(
          '2606:4700:4700::1111', // CloudFlare
          type: InternetAddressType.IPv6,
        ),
      ),
      AddressCheckOptions(
        address: InternetAddress(
          '8.8.4.4', // Google
          type: InternetAddressType.IPv4,
        ),
      ),
      AddressCheckOptions(
        address: InternetAddress(
          '2001:4860:4860::8888', // Google
          type: InternetAddressType.IPv6,
        ),
      ),
      AddressCheckOptions(
        address: InternetAddress(
          '208.67.222.222', // OpenDNS
          type: InternetAddressType.IPv4,
        ), // OpenDNS
      ),
      AddressCheckOptions(
        address: InternetAddress(
          '2620:0:ccc::2', // OpenDNS
          type: InternetAddressType.IPv6,
        ), // OpenDNS
      ),
    ],
  );

  late List<AddressCheckOptions> _addresses;

  List<AddressCheckOptions> get addresses => _addresses;

  set addresses(List<AddressCheckOptions> value) {
    _addresses = List<AddressCheckOptions>.unmodifiable(value);
    _maybeEmitStatusUpdate();
  }

  static final InternetConnectionChecker _instance =
      InternetConnectionChecker.createInstance();

  /// Ping a single address. See [AddressCheckOptions] for
  /// info on the accepted argument.
  Future<AddressCheckResult> isHostReachable(
    AddressCheckOptions options,
  ) async {
    Socket? sock;
    try {
      sock = await Socket.connect(
        options.address ?? options.hostname,
        options.port,
        timeout: options.timeout,
      )
        ..destroy();
      return AddressCheckResult(
        options,
        isSuccess: true,
      );
    } on Exception catch (_) {
      sock?.destroy();
      return AddressCheckResult(
        options,
        isSuccess: false,
      );
    }
  }

  Future<bool> get hasConnection async {
    final Completer<bool> result = Completer<bool>();
    int length = addresses.length;

    for (final AddressCheckOptions addressOptions in addresses) {
      // ignore: unawaited_futures
      isHostReachable(addressOptions).then(
        (request) {
          length -= 1;
          if (!result.isCompleted) {
            if (request.isSuccess) {
              result.complete(true);
            } else if (length == 0) {
              result.complete(false);
            }
          }
        },
      );
    }

    return result.future;
  }

  Future<InternetConnectionStatus> get connectionStatus async =>
      await hasConnection
          ? InternetConnectionStatus.connected
          : InternetConnectionStatus.disconnected;

  final Duration checkInterval;
  final Duration checkTimeout;

  Future<void> _maybeEmitStatusUpdate([
    Timer? timer,
  ]) async {
    // just in case
    _timerHandle?.cancel();
    timer?.cancel();

    final InternetConnectionStatus currentStatus = await connectionStatus;

    // only send status update if last status differs from current
    // and if someone is actually listening
    if (_lastStatus != currentStatus && _statusController.hasListener) {
      _statusController.add(currentStatus);
    }

    // start new timer only if there are listeners
    if (!_statusController.hasListener) return;
    _timerHandle = Timer(checkInterval, _maybeEmitStatusUpdate);

    // update last status
    _lastStatus = currentStatus;
  }

  InternetConnectionStatus? _lastStatus;
  Timer? _timerHandle;

  final StreamController<InternetConnectionStatus> _statusController =
      StreamController<InternetConnectionStatus>.broadcast();

  Stream<InternetConnectionStatus> get onStatusChange =>
      _statusController.stream;

  bool get hasListeners => _statusController.hasListener;

  bool get isActivelyChecking => _statusController.hasListener;
}
