import 'package:flutter/material.dart';

void main() => runApp(const BloodDonorApp());

const Color bloodRed = Color(0xFFC62828);
const Color paleRed = Color(0xFFFFEBEE);

class Donor {
  Donor({
    required this.name,
    required this.bloodGroup,
    required this.city,
    required this.phone,
    this.available = true,
  });

  final String name;
  final String bloodGroup;
  final String city;
  final String phone;
  bool available;
}

class BloodRequest {
  BloodRequest({
    required this.patientName,
    required this.bloodGroup,
    required this.city,
    required this.hospital,
    required this.units,
    required this.phone,
    required this.urgency,
  });

  final String patientName;
  final String bloodGroup;
  final String city;
  final String hospital;
  final int units;
  final String phone;
  final String urgency;
}

class BloodDonorApp extends StatefulWidget {
  const BloodDonorApp({super.key});

  @override
  State<BloodDonorApp> createState() => _BloodDonorAppState();
}

class _BloodDonorAppState extends State<BloodDonorApp> {
  int selectedTab = 0;

  final List<Donor> donors = [
    Donor(name: 'Demo Donor 1', bloodGroup: 'O+', city: 'Vijayawada', phone: '9000000001'),
    Donor(name: 'Demo Donor 2', bloodGroup: 'B+', city: 'Guntur', phone: '9000000002'),
    Donor(name: 'Demo Donor 3', bloodGroup: 'A+', city: 'Vijayawada', phone: '9000000003'),
  ];
  final List<BloodRequest> requests = [];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        donorCount: donors.length,
        requestCount: requests.length,
        onFindDonors: () => setState(() => selectedTab = 1),
        onCreateRequest: () => _openRequestForm(),
        onRegisterDonor: () => _openDonorForm(),
      ),
      DonorSearchPage(donors: donors),
      RequestsPage(requests: requests),
      AboutPage(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donor Emergency Network',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: bloodRed),
        scaffoldBackgroundColor: const Color(0xFFFFFAFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: bloodRed,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Blood Donor Network', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              tooltip: 'About this project',
              onPressed: () => setState(() => selectedTab = 3),
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
        body: IndexedStack(index: selectedTab, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedTab,
          onDestinationSelected: (index) => setState(() => selectedTab = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Find Donors'),
            NavigationDestination(icon: Icon(Icons.emergency_outlined), label: 'Requests'),
            NavigationDestination(icon: Icon(Icons.volunteer_activism), label: 'About SDG'),
          ],
        ),
      ),
    );
  }

  Future<void> _openDonorForm() async {
    final donor = await Navigator.of(context).push<Donor>(
      MaterialPageRoute(builder: (_) => const DonorFormPage()),
    );
    if (donor != null && mounted) {
      setState(() => donors.add(donor));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Donor added on this device.')));
    }
  }

  Future<void> _openRequestForm() async {
    final request = await Navigator.of(context).push<BloodRequest>(
      MaterialPageRoute(builder: (_) => const RequestFormPage()),
    );
    if (request != null && mounted) {
      setState(() => requests.insert(0, request));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency request created on this device.')));
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.donorCount,
    required this.requestCount,
    required this.onFindDonors,
    required this.onCreateRequest,
    required this.onRegisterDonor,
  });

  final int donorCount;
  final int requestCount;
  final VoidCallback onFindDonors;
  final VoidCallback onCreateRequest;
  final VoidCallback onRegisterDonor;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: bloodRed,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.volunteer_activism, color: Colors.white, size: 44),
              SizedBox(height: 14),
              Text('Every drop can\nmake a difference.', style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Connect with potential blood donors and help spread awareness.', style: TextStyle(color: Colors.white, fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: _StatCard(label: 'Demo donors', value: '$donorCount', icon: Icons.people_alt_outlined)),
          const SizedBox(width: 12),
          Expanded(child: _StatCard(label: 'Requests', value: '$requestCount', icon: Icons.bloodtype_outlined)),
        ]),
        const SizedBox(height: 22),
        const Text('What do you need today?', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _ActionCard(
          icon: Icons.emergency,
          title: 'Request blood urgently',
          subtitle: 'Create a request with blood group and hospital details.',
          buttonText: 'Create request',
          onTap: onCreateRequest,
          urgent: true,
        ),
        const SizedBox(height: 12),
        _ActionCard(
          icon: Icons.search,
          title: 'Find a donor',
          subtitle: 'Search the sample donor list by blood group and city.',
          buttonText: 'Search donors',
          onTap: onFindDonors,
        ),
        const SizedBox(height: 12),
        _ActionCard(
          icon: Icons.favorite_border,
          title: 'Become a donor',
          subtitle: 'Add your details to the demo donor directory.',
          buttonText: 'Register',
          onTap: onRegisterDonor,
        ),
        const SizedBox(height: 18),
        const Text('Important: This student project is a prototype. It does not contact hospitals or verify donor eligibility. For a real emergency, contact local emergency services and a hospital blood bank.', style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: paleRed,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: bloodRed, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ]),
    ),
  );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon, required this.title, required this.subtitle,
    required this.buttonText, required this.onTap, this.urgent = false,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;
  final bool urgent;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: urgent ? bloodRed.withValues(alpha: .35) : Colors.black12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(backgroundColor: paleRed, foregroundColor: bloodRed, child: Icon(icon)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 10),
          Align(alignment: Alignment.centerLeft, child: FilledButton(onPressed: onTap, child: Text(buttonText))),
        ])),
      ]),
    ),
  );
}

class DonorSearchPage extends StatefulWidget {
  const DonorSearchPage({super.key, required this.donors});
  final List<Donor> donors;

  @override
  State<DonorSearchPage> createState() => _DonorSearchPageState();
}

class _DonorSearchPageState extends State<DonorSearchPage> {
  String group = 'All';
  final cityController = TextEditingController();
  final groups = const ['All', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.donors.where((d) =>
      (group == 'All' || d.bloodGroup == group) &&
      (cityController.text.trim().isEmpty || d.city.toLowerCase().contains(cityController.text.trim().toLowerCase()))
    ).toList();

    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Find potential donors', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      DropdownButtonFormField<String>(
        value: group,
        decoration: const InputDecoration(labelText: 'Blood group', prefixIcon: Icon(Icons.bloodtype)),
        items: groups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: (value) => setState(() => group = value ?? 'All'),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: cityController,
        decoration: const InputDecoration(labelText: 'City (optional)', prefixIcon: Icon(Icons.location_city), hintText: 'e.g. Vijayawada'),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 14),
      Text('${filtered.length} result(s)', style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      if (filtered.isEmpty)
        const Padding(padding: EdgeInsets.all(24), child: Text('No matching donors in the demo list. Try another blood group or city.'))
      else
        ...filtered.map((d) => Card(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: paleRed, foregroundColor: bloodRed, child: Text(d.bloodGroup)),
            title: Text(d.name),
            subtitle: Text('${d.city} • ${d.available ? "Availability not verified" : "Unavailable"}'),
            trailing: IconButton(
              tooltip: 'Show demo contact',
              icon: const Icon(Icons.phone_outlined),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Demo contact information'),
                  content: Text('Phone: ${d.phone}\n\nThis is sample data. Confirm identity, consent, eligibility and availability before any real-world contact.'),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                ),
              ),
            ),
          ),
        )),
      const SizedBox(height: 12),
      const Text('Donor eligibility and availability must be confirmed by qualified healthcare staff.', style: TextStyle(color: Colors.black54, fontSize: 12)),
    ]);
  }
}

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key, required this.requests});
  final List<BloodRequest> requests;

  @override
  Widget build(BuildContext context) => requests.isEmpty
      ? const Center(child: Padding(padding: EdgeInsets.all(24), child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.inbox_outlined, size: 56, color: bloodRed), SizedBox(height: 12),
            Text('No emergency requests yet', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            SizedBox(height: 6), Text('Create a request from the Home tab to see it here.', textAlign: TextAlign.center)],
        )))
      : ListView(padding: const EdgeInsets.all(16), children: [
          const Text('Emergency requests', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...requests.map((r) => Card(child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(backgroundColor: paleRed, foregroundColor: bloodRed, child: Text(r.bloodGroup)),
                const SizedBox(width: 10),
                Expanded(child: Text(r.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
                Chip(label: Text(r.urgency)),
              ]),
              const SizedBox(height: 8),
              Text('Hospital: ${r.hospital}'),
              Text('City: ${r.city}'),
              Text('Units needed: ${r.units}'),
              Text('Contact: ${r.phone}'),
            ]),
          ))),
        ]);
}

class DonorFormPage extends StatefulWidget {
  const DonorFormPage({super.key});
  @override
  State<DonorFormPage> createState() => _DonorFormPageState();
}

class _DonorFormPageState extends State<DonorFormPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final city = TextEditingController();
  final phone = TextEditingController();
  String group = 'O+';
  bool consent = false;

  @override
  void dispose() { name.dispose(); city.dispose(); phone.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Donor registration')),
    body: Form(key: formKey, child: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Register as a potential donor', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Use test details for your classroom demonstration.'),
      const SizedBox(height: 18),
      TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Full name'), validator: _required),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        value: group, decoration: const InputDecoration(labelText: 'Blood group'),
        items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: (v) => setState(() => group = v ?? 'O+'),
      ),
      const SizedBox(height: 12),
      TextFormField(controller: city, decoration: const InputDecoration(labelText: 'City'), validator: _required),
      const SizedBox(height: 12),
      TextFormField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone number'), validator: (v) {
        if (v == null || !RegExp(r'^[0-9]{10}$').hasMatch(v.trim())) return 'Enter a 10-digit phone number';
        return null;
      }),
      const SizedBox(height: 12),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: consent,
        onChanged: (v) => setState(() => consent = v ?? false),
        title: const Text('I have permission to use these details for this demo.'),
        controlAffinity: ListTileControlAffinity.leading,
      ),
      const SizedBox(height: 14),
      FilledButton.icon(
        onPressed: () {
          if (!formKey.currentState!.validate()) return;
          if (!consent) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please confirm consent before continuing.')));
            return;
          }
          Navigator.pop(context, Donor(name: name.text.trim(), bloodGroup: group, city: city.text.trim(), phone: phone.text.trim()));
        },
        icon: const Icon(Icons.check_circle_outline), label: const Text('Save donor'),
      ),
    ])),
  );
}

class RequestFormPage extends StatefulWidget {
  const RequestFormPage({super.key});
  @override
  State<RequestFormPage> createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  final formKey = GlobalKey<FormState>();
  final patient = TextEditingController();
  final city = TextEditingController();
  final hospital = TextEditingController();
  final phone = TextEditingController();
  String group = 'O+';
  String urgency = 'Urgent';
  int units = 1;

  @override
  void dispose() { patient.dispose(); city.dispose(); hospital.dispose(); phone.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Emergency blood request')),
    body: Form(key: formKey, child: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Request blood', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('This form creates a local demo request; it does not alert donors.'),
      const SizedBox(height: 18),
      TextFormField(controller: patient, decoration: const InputDecoration(labelText: 'Patient / requester name'), validator: _required),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        value: group, decoration: const InputDecoration(labelText: 'Required blood group'),
        items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: (v) => setState(() => group = v ?? 'O+'),
      ),
      const SizedBox(height: 12),
      TextFormField(controller: hospital, decoration: const InputDecoration(labelText: 'Hospital / blood bank'), validator: _required),
      const SizedBox(height: 12),
      TextFormField(controller: city, decoration: const InputDecoration(labelText: 'City'), validator: _required),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(
        value: units, decoration: const InputDecoration(labelText: 'Units required'),
        items: [1, 2, 3, 4, 5].map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
        onChanged: (v) => setState(() => units = v ?? 1),
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        value: urgency, decoration: const InputDecoration(labelText: 'Priority'),
        items: const ['Urgent', 'Within 24 hours', 'Planned'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => setState(() => urgency = v ?? 'Urgent'),
      ),
      const SizedBox(height: 12),
      TextFormField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Contact phone'), validator: (v) {
        if (v == null || !RegExp(r'^[0-9]{10}$').hasMatch(v.trim())) return 'Enter a 10-digit phone number';
        return null;
      }),
      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: () {
          if (!formKey.currentState!.validate()) return;
          Navigator.pop(context, BloodRequest(
            patientName: patient.text.trim(), bloodGroup: group, city: city.text.trim(),
            hospital: hospital.text.trim(), units: units, phone: phone.text.trim(), urgency: urgency,
          ));
        },
        icon: const Icon(Icons.send), label: const Text('Submit request'),
      ),
    ])),
  );
}

String? _required(String? value) =>
    value == null || value.trim().isEmpty ? 'This field is required' : null;

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: paleRed, borderRadius: BorderRadius.circular(18)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.health_and_safety, color: bloodRed, size: 42),
        SizedBox(height: 12),
        Text('SDG 3: Good Health and Well-being', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('This project aims to make it easier to find potential blood donors and raise awareness about timely blood donation.'),
      ]),
    ),
    const SizedBox(height: 18),
    const Text('Project objectives', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    const ListTile(leading: Icon(Icons.check_circle_outline, color: bloodRed), title: Text('Organise donor information by blood group and city.')),
    const ListTile(leading: Icon(Icons.check_circle_outline, color: bloodRed), title: Text('Record emergency blood requests in a simple interface.')),
    const ListTile(leading: Icon(Icons.check_circle_outline, color: bloodRed), title: Text('Promote responsible donation awareness and community support.')),
    const Divider(),
    const Text('Current prototype limitations', style: TextStyle(fontWeight: FontWeight.bold)),
    const SizedBox(height: 6),
    const Text('Data stays in app memory and resets when the app restarts. There is no login, cloud database, verified donor workflow, map, or automatic notification yet. Do not enter real personal or medical information in this demo.'),
  ]);
}
