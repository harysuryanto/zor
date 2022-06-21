import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdPlacement {
  homeScreen,
  allPlansScreen,
  detailPlanScreen,
}

class AdBanner extends StatefulWidget {
  const AdBanner({
    Key? key,
    this.adPlacement = AdPlacement.homeScreen,
  }) : super(key: key);

  final AdPlacement adPlacement;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
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

  String _adUnitIdAndroid(AdPlacement adPlacement) {
    switch (adPlacement) {
      case AdPlacement.homeScreen:
        return 'ca-app-pub-9675217052405779/4840390767';
      case AdPlacement.allPlansScreen:
        return 'ca-app-pub-9675217052405779/9697965774';
      case AdPlacement.detailPlanScreen:
        return 'ca-app-pub-9675217052405779/4717101834';
      default:
        return _adUnitIdAndroid(AdPlacement.homeScreen);
    }
  }

  String _adUnitIdIos(AdPlacement adPlacement) {
    // Currently ads are not supported on iOS.
    // So it returns adUnitId from AdPlacement.homeScreen for Android.
    return _adUnitIdAndroid(AdPlacement.homeScreen);
  }

  _initializeAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isAndroid
          ? _adUnitIdAndroid(widget.adPlacement)
          : _adUnitIdIos(widget.adPlacement),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error) {
          log('Ad failed to load: ${error.message}');
          _bannerAd.dispose();
        },
      ),
      request: const AdRequest(),
    );
  }
}
