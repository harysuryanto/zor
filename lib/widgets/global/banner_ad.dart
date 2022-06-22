import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({
    Key? key,
    this.adPlacement = AdPlacement.homeScreen,
  }) : super(key: key);

  final AdPlacement adPlacement;

  @override
  Widget build(BuildContext context) {
    if (!_isDeviceSupported) return const SizedBox();

    return _AdBannerMobile(adPlacement: adPlacement);
  }
}

class _AdBannerMobile extends StatefulWidget {
  const _AdBannerMobile({
    Key? key,
    this.adPlacement = AdPlacement.homeScreen,
  }) : super(key: key);

  final AdPlacement adPlacement;

  @override
  State<_AdBannerMobile> createState() => __AdBannerMobileState();
}

class __AdBannerMobileState extends State<_AdBannerMobile> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeAd();
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded) {
      return SizedBox(
        height: _bannerAd.size.height.toDouble(),
        width: _bannerAd.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd),
      );
    }

    return const SizedBox();
  }

  String _adUnitId({AdPlacement? adPlacement}) {
    if (Platform.isAndroid) {
      switch (adPlacement) {
        case AdPlacement.homeScreen:
          return 'ca-app-pub-9675217052405779/4840390767';
        case AdPlacement.allPlansScreen:
          return 'ca-app-pub-9675217052405779/9697965774';
        case AdPlacement.detailPlanScreen:
          return 'ca-app-pub-9675217052405779/4717101834';
        default:
          return _adUnitId(adPlacement: AdPlacement.homeScreen);
      }
    } else if (Platform.isIOS) {
      throw UnsupportedError("Currently ads are not supported on iOS.");
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  void _initializeAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: _adUnitId(adPlacement: widget.adPlacement),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error) {
          _bannerAd.dispose();
          print('Ad failed to load: ${error.message}');
        },
      ),
      request: const AdRequest(),
    );
  }
}

enum AdPlacement {
  homeScreen,
  allPlansScreen,
  detailPlanScreen,
}

const List _supportedDevices = [TargetPlatform.android];
final bool _isDeviceSupported =
    _supportedDevices.contains(defaultTargetPlatform);
