import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main() => runApp(const BloodNetApp());
const kGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
const kCompatible = {
  'A+': ['A+', 'A-', 'O+', 'O-'], 'A-': ['A-', 'O-'], 'B+': ['B+', 'B-', 'O+', 'O-'], 'B-': ['B-', 'O-'],
  'AB+': kGroups, 'AB-': ['A-', 'B-', 'AB-', 'O-'], 'O+': ['O+', 'O-'], 'O-': ['O-'],
};
const kRed = Color(0xFFB3122D);
const gap = SizedBox(height: 12);
const pad = EdgeInsets.all(16);
TextStyle bold(double s, [Color? c]) => TextStyle(fontSize: s, fontWeight: FontWeight.w700, color: c);
Widget box(Widget child) => Card(elevation: 0, color: Colors.white, child: child);
Widget badge(String g) => CircleAvatar(backgroundColor: kRed, child: Text(g, style: bold(13, Colors.white)));
Widget msg(String t) => Padding(padding: const EdgeInsets.all(32), child: Text(t, textAlign: TextAlign.center));
void toast(BuildContext c, String t) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(t)));
class Donor {
  final String name, group, city, phone;
  bool available;
  Donor(this.name, this.group, this.city, this.phone, [this.available = true]);
}
class Req {
  final String patient, group, hospital, city, phone;
  final int units;
  final bool urgent;
  final DateTime time;
  bool fulfilled = false;
  Req(this.patient, this.group, this.units, this.hospital, this.city, this.phone, this.urgent, this.time);
  String get ago {
    final m = DateTime.now().difference(time).inMinutes;
    return m < 1 ? 'just now' : m < 60 ? '$m min ago' : m < 1440 ? '${m ~/ 60} h ago' : '${m ~/ 1440} d ago';
  }
}
class Store extends ChangeNotifier {
  final donors = <Donor>[
    Donor('Ravi Teja', 'O+', 'Guntur', '9876500001'), Donor('Sneha Reddy', 'A+', 'Vijayawada', '9876500002'),
    Donor('Karthik', 'B+', 'Guntur', '9876500003'), Donor('Priya', 'O-', 'Tenali', '9876500004'),
    Donor('Anil Kumar', 'AB+', 'Vijayawada', '9876500005', false), Donor('Meena', 'A-', 'Guntur', '9876500006'),
  ];
  final requests = <Req>[
    Req('Lakshmi', 'O-', 2, 'Government General Hospital', 'Guntur', '9000000001', true,
        DateTime.now().subtract(const Duration(minutes: 25))),
    Req('Suresh', 'B+', 1, 'Ramesh Hospitals', 'Vijayawada', '9000000002', false,
        DateTime.now().subtract(const Duration(hours: 3))),
  ];
  String filter = 'All', query = '';
  List<Donor> get filtered => donors
      .where((d) => (filter == 'All' || d.group == filter) && d.city.toLowerCase().contains(query.toLowerCase().trim()))
      .toList();
  List<Donor> matchesFor(Req r) => donors.where((d) => d.available && kCompatible[r.group]!.contains(d.group)).toList();
  void update(VoidCallback change) { change(); notifyListeners(); }
}
final store = Store();
class BloodNetApp extends StatelessWidget {
  const BloodNetApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Blood Donor Emergency Network',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: kRed, primary: kRed),
            scaffoldBackgroundColor: const Color(0xFFFBF7F5),
            inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), isDense: true)),
        home: const Shell(),
      );
}
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}
class _ShellState extends State<Shell> {
  int index = 0;
  void go(int i) => setState(() => index = i);
  Widget stat(String n, String label) => Expanded(
      child: box(Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(children: [Text(n, style: bold(24, kRed)), Text(label, style: const TextStyle(fontSize: 12))]))));
  Widget home(BuildContext context) => ListView(padding: pad, children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(20)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Need blood? Reach a matching donor in minutes.', style: bold(28, Colors.white)),
            const SizedBox(height: 8),
            const Text('Post an emergency request or register to donate. Every unit can save up to three lives.',
                style: TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 20),
            Wrap(spacing: 12, runSpacing: 12, children: [
              FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: kRed),
                  onPressed: () => showForm(context, request: true),
                  icon: const Icon(Icons.emergency), label: const Text('Request blood')),
              OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white)),
                  onPressed: () => showForm(context, request: false),
                  icon: const Icon(Icons.volunteer_activism), label: const Text('Become a donor')),
            ]),
          ]),
        ),
        gap,
        Row(children: [
          stat('${store.donors.length}', 'Registered donors'),
          stat('${store.donors.where((d) => d.available).length}', 'Available now'),
          stat('${store.requests.where((r) => !r.fulfilled).length}', 'Open requests'),
        ]),
        gap,
        Text('Find donors by blood group', style: bold(18)),
        const SizedBox(height: 10),
        Wrap(spacing: 10, runSpacing: 10, children: [
          for (final g in kGroups)
            ActionChip(label: Text(g, style: bold(14)), onPressed: () { store.update(() => store.filter = g); go(1); }),
        ]),
        const SizedBox(height: 24),
        box(const Padding(
            padding: pad,
            child: Text(
                'Supports UN SDG 3 – Good Health and Well-being: faster access to safe blood during accidents, surgeries and disasters.'))),
      ]);
  Widget donors(BuildContext context) {
    final list = store.filtered;
    return ListView(padding: pad, children: [
      TextField(
          onChanged: (q) => store.update(() => store.query = q),
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Search by city')),
      gap,
      SizedBox(
          height: 40,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (final g in ['All', ...kGroups])
              Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                      label: Text(g), selected: store.filter == g, onSelected: (_) => store.update(() => store.filter = g))),
          ])),
      gap,
      if (list.isEmpty) msg('No donors match this search. Try another city or blood group.'),
      for (final d in list) donorTile(context, d),
      const SizedBox(height: 80),
    ]);
  }
  Widget requests(BuildContext context) => ListView(padding: pad, children: [
        if (store.requests.isEmpty) msg('No requests yet. Tap “Request blood” to post one.'),
        for (final r in store.requests) requestCard(context, r),
        const SizedBox(height: 80),
      ]);
  @override
  Widget build(BuildContext context) {
    final pages = [home(context), donors(context), requests(context)];
    const dests = [(Icons.home_outlined, Icons.home, 'Home'), (Icons.bloodtype_outlined, Icons.bloodtype, 'Donors'),
      (Icons.emergency_outlined, Icons.emergency, 'Requests')];
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kRed, foregroundColor: Colors.white, title: Text('Blood Donor Emergency Network', style: bold(18))),
      floatingActionButton: index == 0
          ? null
          : FloatingActionButton.extended(
              backgroundColor: kRed, foregroundColor: Colors.white,
              onPressed: () => showForm(context, request: index == 2),
              icon: Icon(index == 2 ? Icons.emergency : Icons.add),
              label: Text(index == 2 ? 'Request blood' : 'Register as donor')),
      body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: ListenableBuilder(listenable: store, builder: (_, __) => pages[index]))),
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: go, destinations: [
        for (final d in dests) NavigationDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: d.$3),
      ]),
    );
  }
}
Widget donorTile(BuildContext context, Donor d) => box(ListTile(
      leading: badge(d.group),
      title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${d.city} • ${d.available ? "Available" : "Unavailable"}'),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Switch(value: d.available, onChanged: (_) => store.update(() => d.available = !d.available)),
        IconButton(icon: const Icon(Icons.call, color: kRed), tooltip: 'Contact donor',
            onPressed: () => showContact(context, d.name, d.phone)),
      ]),
    ));
Widget requestCard(BuildContext context, Req r) => box(Padding(
    padding: pad,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        badge(r.group),
        const SizedBox(width: 12),
        Expanded(child: Text('${r.patient} needs ${r.units} unit(s)', style: bold(16))),
        if (r.fulfilled)
          const Chip(label: Text('Fulfilled'))
        else if (r.urgent)
          const Chip(label: Text('Urgent'), backgroundColor: Color(0xFFFFE0E3), side: BorderSide.none),
      ]),
      const SizedBox(height: 8),
      Text('${r.hospital}, ${r.city} • ${r.ago}'),
      gap,
      Wrap(spacing: 8, runSpacing: 8, children: [
        OutlinedButton.icon(
            onPressed: () => showContact(context, r.patient, r.phone),
            icon: const Icon(Icons.call), label: const Text('Call requester')),
        FilledButton.tonalIcon(
            onPressed: () => showMatches(context, r),
            icon: const Icon(Icons.people), label: Text('${store.matchesFor(r).length} matching donors')),
        if (!r.fulfilled)
          TextButton(onPressed: () => store.update(() => r.fulfilled = true), child: const Text('Mark fulfilled')),
      ]),
    ])));
void showContact(BuildContext context, String name, String phone) => showDialog(
    context: context,
    builder: (_) => AlertDialog(title: Text(name), content: SelectableText('Phone: $phone'), actions: [
          TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: phone));
                Navigator.pop(context);
                toast(context, 'Number copied');
              },
              child: const Text('Copy number')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ]));
void showMatches(BuildContext context, Req r) {
  final list = store.matchesFor(r);
  showModalBottomSheet(
      context: context,
      builder: (_) => ListView(padding: pad, children: [
            Text('Donors who can give to ${r.group}', style: bold(18)),
            const SizedBox(height: 8),
            if (list.isEmpty) const Text('No available donors match yet. Share this request to reach more people.'),
            for (final d in list) donorTile(context, d),
          ]));
}
void showForm(BuildContext context, {required bool request}) {
  final key = GlobalKey<FormState>();
  final name = TextEditingController(), city = TextEditingController(), phone = TextEditingController();
  final hospital = TextEditingController(), units = TextEditingController(text: '1');
  String group = 'O+';
  bool urgent = true;
  void submit(BuildContext ctx) {
    if (!key.currentState!.validate()) return;
    store.update(() {
      if (request) {
        store.requests.insert(0, Req(name.text.trim(), group, int.parse(units.text), hospital.text.trim(),
            city.text.trim(), phone.text.trim(), urgent, DateTime.now()));
      } else {
        store.donors.insert(0, Donor(name.text.trim(), group, city.text.trim(), phone.text.trim()));
      }
    });
    Navigator.pop(ctx);
    toast(context, request ? 'Request posted' : 'You are registered. Thank you!');
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
      child: StatefulBuilder(
        builder: (ctx, setS) => Form(
          key: key,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(request ? 'Request blood' : 'Register as donor', style: bold(20)),
              const SizedBox(height: 16),
              field(name, request ? 'Patient name' : 'Full name', required: true),
              gap,
              Row(children: [
                Expanded(
                    child: DropdownButtonFormField<String>(
                        initialValue: group, decoration: const InputDecoration(labelText: 'Blood group'),
                        items: [for (final g in kGroups) DropdownMenuItem(value: g, child: Text(g))],
                        onChanged: (v) => setS(() => group = v!))),
                if (request) ...[const SizedBox(width: 12), Expanded(child: field(units, 'Units', number: true))],
              ]),
              if (request) ...[gap, field(hospital, 'Hospital', required: true)],
              gap,
              field(city, 'City', required: true),
              gap,
              field(phone, request ? 'Contact number' : 'Phone number', phone: true),
              if (request)
                SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Mark as urgent'),
                    value: urgent, onChanged: (v) => setS(() => urgent = v)),
              const SizedBox(height: 16),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton(onPressed: () => submit(ctx), child: Text(request ? 'Post request' : 'Register'))),
            ]),
          ),
        ),
      ),
    ),
  );
}
Widget field(TextEditingController c, String label, {bool required = false, bool phone = false, bool number = false}) {
  return TextFormField(
    controller: c,
    keyboardType: (phone || number) ? TextInputType.number : TextInputType.text, decoration: InputDecoration(labelText: label),
    inputFormatters: (phone || number) ? [FilteringTextInputFormatter.digitsOnly] : null,
    validator: (v) {
      final t = (v ?? '').trim();
      if (phone) return t.length == 10 ? null : 'Enter a 10-digit number';
      if (number) return (int.tryParse(t) ?? 0) > 0 ? null : 'Enter at least 1';
      return required && t.isEmpty ? 'This field is required' : null;
    },
  );
}
