import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/models/live_departures.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/screens/station/components/departures_card.dart';
import 'package:metrovalencia_reloaded/screens/station/components/station_adress.dart';
import 'package:metrovalencia_reloaded/screens/station/components/station_lines.dart';
import 'package:metrovalencia_reloaded/services/fgv/fgv_live_schedule_service.dart';
import 'package:metrovalencia_reloaded/services/service_locator.dart';
import 'package:metrovalencia_reloaded/utils/snackbar_utils.dart';

class StationScreen extends StatefulWidget {
  const StationScreen(this.station, {Key? key}) : super(key: key);

  @override
  State<StationScreen> createState() => _StationScreenState();

  final Station station;
}

class _StationScreenState extends State<StationScreen> {
  AbstractFgvLiveScheduleService liveScheduleService =
      getIt<AbstractFgvLiveScheduleService>();
  List<LiveDepartures> liveDepartures = [];

  bool showDepartures = false;

  @override
  void initState() {
    super.initState();
    loadLiveDepartures();
  }

  void loadLiveDepartures() {
    try {
      setState(() {
        showDepartures = false;
        liveScheduleService.getLiveSchedules(widget.station.id).then(
              (liveSchedules) => {
                setState(
                  () => {
                    liveDepartures = liveSchedules,
                    showDepartures = true,
                  },
                )
              },
            );
      });
    } catch (e) {
      SnackbarUtils.textSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StationLines(station: widget.station),
        StationAdress(station: widget.station),
        DeparturesCard(
          showDepartures: showDepartures,
          liveDepartures: liveDepartures,
          onDeparturesRefresh: loadLiveDepartures,
        ),
      ],
    );
  }
}
