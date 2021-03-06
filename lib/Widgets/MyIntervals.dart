import 'package:flutter/material.dart';

import '../storage.dart';

class MyIntervals extends StatefulWidget {

	@override
	State<StatefulWidget> createState() => _MyIntervalsState();

}

class _MyIntervalsState extends State<MyIntervals> {
	
	bool _isLoading = true;
	bool _err = false;
	List<Widget> _widgetIntervals = [];

	void loadWidgets() async {
		List intervals = await getIntervals();
		print(intervals);
		print('initializing MyIntervals');
		setState(() {
			_isLoading = false;
			_widgetIntervals = (intervals.isNotEmpty) ? intervals.map((e) => IntervalWidget(data: e)).toList() : [];
		});
	}

	@override
	void initState() {
		super.initState();
		loadWidgets();
	}

	// TODO create loading screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
		backgroundColor: Colors.black,
      appBar: AppBar(
				centerTitle: true,
        title: const Text('My Intervals'),
				backgroundColor: Colors.black,
      ),
      body: 
				(_isLoading) ? const Text('Loading...', style: TextStyle(color: Colors.white,)) : 
					(_widgetIntervals.isNotEmpty) ?
						ListView(
							children: _widgetIntervals,
						)
					: const Text('Nothing...', style: TextStyle(color: Colors.white,)),
    );
  }
}

class IntervalWidget extends StatefulWidget {

	const IntervalWidget({Key? key, required this.data}) : super(key: key);

	final IntervalInterface data;

	@override
	State<StatefulWidget> createState() => _IntervalWidgetState();
}

class _IntervalWidgetState extends State<IntervalWidget> {

	// TODO reconsider menu dropping/toggling implementation
	bool _isToggled = false;


	@override
	Widget build(BuildContext context) {
		IntervalInterface data = widget.data;
		List<Widget> sessions = data.sessions.map((e) => sessionWidget(e)).toList();
		return Align(
		child: GestureDetector(
			onTap: () {
				setState(() {
					_isToggled = !_isToggled;
				});
			},
			child: Container(
				width: double.infinity,
				constraints: const BoxConstraints(maxWidth: 385),
				padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
				decoration: BoxDecoration(
					 borderRadius: BorderRadius.circular(15),
					 color: const Color.fromRGBO(91, 91, 91, 100),

				),
				margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
				//child:  Text(data.title, style: const TextStyle(color: Colors.white)),
				child: Column(
					children: [
						Container(
							width: double.infinity,
							margin: const EdgeInsets.only(bottom: 15),
							child: Text(data.title, style: const TextStyle(color: Colors.white)),
						),
						Row(
							children: sessions,
						),
						getToggleButtons(),
					],
				),
			)
		));
	}

	Widget getToggleButtons() {
		if (_isToggled) {
			return Container(
						margin: const EdgeInsets.only(top: 15,),
						child: Wrap(
							spacing: 0,
							children: [
					IconButton(onPressed: () {
						// TODO editing of the current interval
					}, iconSize: 50, icon: const Icon(Icons.edit_rounded, color: Colors.blue)),
					IconButton(onPressed: () {
						// TODO reseting of the current interval
						// TODO confirmation dialogue when the timer is running
						setCurrentInterval(widget.data.id);
						Navigator.pop(context);
						print(widget.data.id);
					}, iconSize: 50, icon: const Icon(Icons.play_circle_rounded, color: Colors.blue)),
							],
						),
					);
		}
		return const SizedBox();
	}

	Widget sessionWidget(SessionInterface s) {
		List c = s.color;
		// TODO change the length parsing
		String len = (s.len%60).toString();
		// TODO change text color black/white depending on the s.color
		return Container(
			width: 35,
			height: 35,
			decoration: BoxDecoration(
				color: Color.fromRGBO(c[0], c[1], c[2], c[3].toDouble()),
				borderRadius: BorderRadius.circular(100),
			),
			padding: const EdgeInsets.all(7),
			margin: const EdgeInsets.only(right: 10),
			child: Center( child: Text(len, style: const TextStyle(color: Colors.white)) ),
			);
	}
}
