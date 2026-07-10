import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vpn_providers.dart';
import 'dart:ui';

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnState = ref.watch(vpnProvider);
    final vpnNotifier = ref.read(vpnProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Select Server',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Builder(
            builder: (context) {
              if (vpnState.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (vpnState.servers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.dns_rounded,
                        size: 80,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No servers found.',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () =>
                            vpnNotifier.fetchServers(forceRefresh: true),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => vpnNotifier.fetchServers(forceRefresh: true),
                color: Colors.blueAccent,
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    top: 100,
                    bottom: 20,
                    left: 16,
                    right: 16,
                  ),
                  itemCount: vpnState.servers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final server = vpnState.servers[index];
                    final isSelected = vpnState.selectedServer?.ip == server.ip;
                    final speedMbps = (server.speed / 1000000).toStringAsFixed(
                      1,
                    );

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: InkWell(
                          onTap: () {
                            vpnNotifier.selectServer(server);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blueAccent.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blueAccent.withValues(alpha: 0.6)
                                    : Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Flag
                                Text(
                                  server.flagEmoji,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(width: 16),

                                // Server Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        server.countryLong,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.speed,
                                            size: 14,
                                            color: Colors.greenAccent,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$speedMbps Mbps',
                                            style: const TextStyle(
                                              color: Colors.greenAccent,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(
                                            Icons.network_ping,
                                            size: 14,
                                            color: Colors.orangeAccent,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${server.ping} ms',
                                            style: const TextStyle(
                                              color: Colors.orangeAccent,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Selected Indicator
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.blueAccent,
                                    size: 28,
                                  )
                                else
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white30,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
