import 'package:apple_ui_kit/apple_ui_kit.dart';
import 'package:flutter/material.dart';

/// One screen that shows both design languages side by side: a Big Sur window
/// on the left, an iOS 27 phone surface on the right.
void main() => runApp(const DemoApp());

void _noop() {}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _Demo(),
    );
  }
}

class _Demo extends StatefulWidget {
  const _Demo();

  @override
  State<_Demo> createState() => _DemoState();
}

class _DemoState extends State<_Demo> {
  int _macSection = 0;
  int _macIndex = 0;
  bool _macToggle = true;
  double _macSlider = 0.45;
  int _source = 0;

  int _tab = 0;
  bool _iosToggle = true;
  int _segment = 1;
  bool _sheetOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101013),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Wrap(
            spacing: 40,
            runSpacing: 40,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: <Widget>[
              MacWindow(
                width: 620,
                height: 420,
                title: 'Documents',
                sidebar: MacSidebar(
                  sections: <MacSidebarSection>[
                    MacSidebarSection(
                      title: 'Favourites',
                      items: <MacSidebarItem>[
                        MacSidebarItem(
                          label: 'Recents',
                          icon: Icons.schedule,
                          selected: _macSection == 0 && _macIndex == 0,
                        ),
                        MacSidebarItem(
                          label: 'Documents',
                          icon: Icons.folder_outlined,
                          selected: _macSection == 0 && _macIndex == 1,
                        ),
                        MacSidebarItem(
                          label: 'Downloads',
                          icon: Icons.download_outlined,
                          badge: '3',
                          selected: _macSection == 0 && _macIndex == 2,
                        ),
                      ],
                    ),
                    const MacSidebarSection(
                      title: 'Locations',
                      items: <MacSidebarItem>[
                        MacSidebarItem(label: 'iCloud Drive', icon: Icons.cloud_outlined),
                        MacSidebarItem(label: 'Network', icon: Icons.lan_outlined),
                      ],
                    ),
                  ],
                  onSelect: (int s, int i) => setState(() {
                    _macSection = s;
                    _macIndex = i;
                  }),
                ),
                toolbarTrailing: <Widget>[
                  const MacButton(label: 'New', icon: Icons.add, onPressed: _noop),
                  const SizedBox(width: 8),
                  MacSegmentedControl(
                    segments: const <String>['Icons', 'List', 'Columns'],
                    selectedIndex: _source,
                    onChanged: (int i) => setState(() => _source = i),
                    height: 24,
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const MacSearchField(placeholder: 'Search documents'),
                      const SizedBox(height: 14),
                      MacListRow(
                        title: 'Quarterly review.pdf',
                        subtitle: '2.4 MB · Today',
                        leading: const Icon(Icons.picture_as_pdf_outlined),
                        showDisclosure: true,
                        selected: true,
                        onTap: () {},
                      ),
                      MacListRow(
                        title: 'Design system.sketch',
                        subtitle: '18 MB · Yesterday',
                        leading: const Icon(Icons.folder_zip_outlined),
                        onTap: () {},
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: <Widget>[
                          MacSwitch(
                            value: _macToggle,
                            onChanged: (bool v) => setState(() => _macToggle = v),
                          ),
                          const SizedBox(width: 10),
                          const Text('Autosave', style: TextStyle(color: Color(0xFF1D1D1F))),
                          const Spacer(),
                          SizedBox(
                            width: 140,
                            child: MacSlider(
                              value: _macSlider,
                              onChanged: (double v) => setState(() => _macSlider = v),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          MacButton(label: 'Cancel', onPressed: () {}),
                          const SizedBox(width: 8),
                          MacButton(
                            label: 'Apply',
                            style: MacButtonStyle.primary,
                            large: true,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 390,
                height: 720,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(44),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Color(0xFF2B3A67), Color(0xFF7C3AED)],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        const IosNavBar(
                          title: 'Library',
                          subtitle: '24 items',
                          trailing: <Widget>[
                            Icon(Icons.more_horiz, color: Color(0xFFFFFFFF)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: IosSearchField(
                            onChanged: (String _) {},
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: IosSegmentedControl(
                            segments: const <String>['All', 'Recent', 'Shared'],
                            selectedIndex: _segment,
                            onChanged: (int i) => setState(() => _segment = i),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              IosListSection(
                                header: 'Playback',
                                footer: 'Glass surfaces follow the system material.',
                                children: <Widget>[
                                  IosListTile(
                                    title: 'Spatial audio',
                                    leadingIcon: Icons.graphic_eq,
                                    trailing: IosSwitch(
                                      value: _iosToggle,
                                      onChanged: (bool v) => setState(() => _iosToggle = v),
                                    ),
                                  ),
                                  IosListTile(
                                    title: 'Download quality',
                                    subtitle: 'High',
                                    showChevron: true,
                                    showSeparator: false,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              IosListSection(
                                header: 'Actions',
                                children: <Widget>[
                                  IosListTile(
                                    title: 'Open sheet',
                                    leadingIcon: Icons.arrow_upward,
                                    showChevron: true,
                                    showSeparator: false,
                                    onTap: () => setState(() => _sheetOpen = true),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: IosButton(
                                  label: 'Continue',
                                  icon: Icons.arrow_forward,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_sheetOpen)
                          IosSheet(
                            title: 'Now playing',
                            onDismiss: () => setState(() => _sheetOpen = false),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  'Swipe down to dismiss, the way iOS does it.',
                                  style: AppleType.iosSubhead.copyWith(
                                    color: const Color(0xFF8E8E93),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                IosButton(
                                  label: 'Done',
                                  style: IosButtonStyle.tinted,
                                  onPressed: () => setState(() => _sheetOpen = false),
                                ),
                              ],
                            ),
                          ),
                        IosTabBar(
                          items: const <IosTabItem>[
                            IosTabItem(icon: Icons.library_music_outlined, label: 'Library'),
                            IosTabItem(icon: Icons.play_circle_outline, label: 'Listen'),
                            IosTabItem(icon: Icons.search, label: 'Search'),
                          ],
                          selectedIndex: _tab,
                          onChanged: (int i) => setState(() => _tab = i),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
