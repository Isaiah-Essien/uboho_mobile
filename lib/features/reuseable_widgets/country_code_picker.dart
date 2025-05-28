import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utiils/constants/colors.dart';
import '../../utiils/constants/icons.dart'; // <-- your Uboho color class

class CountryCodeDropdown extends StatefulWidget {
  final Function(String code, String flagPath) onChanged;

  const CountryCodeDropdown({super.key, required this.onChanged});

  @override
  State<CountryCodeDropdown> createState() => _CountryCodeDropdownState();
}

class _CountryCodeDropdownState extends State<CountryCodeDropdown> {
  final List<Map<String, String>> _allCountries = [
    {'file': 'algeria_flag.webp', 'name': 'Algeria', 'code': '+213'},
    {'file': 'angola_flag.webp', 'name': 'Angola', 'code': '+244'},
    {'file': 'benin_flag.webp', 'name': 'Benin', 'code': '+229'},
    {'file': 'botswana_flag.webp', 'name': 'Botswana', 'code': '+267'},
    {'file': 'burkina_faso_flag.webp', 'name': 'Burkina Faso', 'code': '+226'},
    {'file': 'burundi_flag.webp', 'name': 'Burundi', 'code': '+257'},
    {'file': 'cameroon_flag.webp', 'name': 'Cameroon', 'code': '+237'},
    {'file': 'cape_verde_flag.webp', 'name': 'Cape Verde', 'code': '+238'},
    {'file': 'central_african_republic.webp', 'name': 'Central African Republic', 'code': '+236'},
    {'file': 'chad_flag.webp', 'name': 'Chad', 'code': '+235'},
    {'file': 'comoros_flag.webp', 'name': 'Comoros', 'code': '+269'},
    {'file': 'congo_drc_flag.webp', 'name': 'Congo (DRC)', 'code': '+243'},
    {'file': 'congo_republic_of_the_flag.webp', 'name': 'Republic of the Congo', 'code': '+242'},
    {'file': 'cote_d_Ivoire_flag.webp', 'name': 'Côte d\'Ivoire', 'code': '+225'},
    {'file': 'djibouti_flag.webp', 'name': 'Djibouti', 'code': '+253'},
    {'file': 'egypt_flag.webp', 'name': 'Egypt', 'code': '+20'},
    {'file': 'equatorial_guinea_flag.webp', 'name': 'Equatorial Guinea', 'code': '+240'},
    {'file': 'eritrea_flag.webp', 'name': 'Eritrea', 'code': '+291'},
    {'file': 'ethiopia_flag.webp', 'name': 'Ethiopia', 'code': '+251'},
    {'file': 'gabon_flag.webp', 'name': 'Gabon', 'code': '+241'},
    {'file': 'gambia_flag.webp', 'name': 'Gambia', 'code': '+220'},
    {'file': 'ghana_flag.webp', 'name': 'Ghana', 'code': '+233'},
    {'file': 'guinea-bissau_flag.webp', 'name': 'Guinea-Bissau', 'code': '+245'},
    {'file': 'guinea_flag.webp', 'name': 'Guinea', 'code': '+224'},
    {'file': 'kenya_flag.webp', 'name': 'Kenya', 'code': '+254'},
    {'file': 'lesotho_flag.webp', 'name': 'Lesotho', 'code': '+266'},
    {'file': 'liberia_flag.webp', 'name': 'Liberia', 'code': '+231'},
    {'file': 'libya_flag_new.webp', 'name': 'Libya', 'code': '+218'},
    {'file': 'madagascar_flag.webp', 'name': 'Madagascar', 'code': '+261'},
    {'file': 'malawi_flag.webp', 'name': 'Malawi', 'code': '+265'},
    {'file': 'mali_flag.webp', 'name': 'Mali', 'code': '+223'},
    {'file': 'mauritania_flag.webp', 'name': 'Mauritania', 'code': '+222'},
    {'file': 'mauritius_flag.webp', 'name': 'Mauritius', 'code': '+230'},
    {'file': 'morocco_flag.webp', 'name': 'Morocco', 'code': '+212'},
    {'file': 'mozambique_flag.webp', 'name': 'Mozambique', 'code': '+258'},
    {'file': 'namibia_flag.webp', 'name': 'Namibia', 'code': '+264'},
    {'file': 'niger_flag.webp', 'name': 'Niger', 'code': '+227'},
    {'file': 'nigeria_flag.webp', 'name': 'Nigeria', 'code': '+234'},
    {'file': 'reunion_flag.webp', 'name': 'Reunion', 'code': '+262'},
    {'file': 'rwanda_flag.webp', 'name': 'Rwanda', 'code': '+250'},
    {'file': 'saint_helena_flag.webp', 'name': 'Saint Helena', 'code': '+290'},
    {'file': 'sao_tome_and_principe_flag.webp', 'name': 'Sao Tome and Principe', 'code': '+239'},
    {'file': 'senegal_flag.webp', 'name': 'Senegal', 'code': '+221'},
    {'file': 'seychelles_flag.webp', 'name': 'Seychelles', 'code': '+248'},
    {'file': 'sierra_leone_flag.webp', 'name': 'Sierra Leone', 'code': '+232'},
    {'file': 'somalia_flag.webp', 'name': 'Somalia', 'code': '+252'},
    {'file': 'south_africa_flag.webp', 'name': 'South Africa', 'code': '+27'},
    {'file': 'south_sudan-flag.webp', 'name': 'South Sudan', 'code': '+211'},
    {'file': 'sudan_flag.webp', 'name': 'Sudan', 'code': '+249'},
    {'file': 'swaziland_flag.webp', 'name': 'Swaziland', 'code': '+268'},
    {'file': 'tanzania_flag.webp', 'name': 'Tanzania', 'code': '+255'},
    {'file': 'togo_flag.webp', 'name': 'Togo', 'code': '+228'},
    {'file': 'tunisia_flag.webp', 'name': 'Tunisia', 'code': '+216'},
    {'file': 'uganda_flag.webp', 'name': 'Uganda', 'code': '+256'},
    {'file': 'western_sahara_flag.webp', 'name': 'Western Sahara', 'code': '+212'},
    {'file': 'zambia_flag.webp', 'name': 'Zambia', 'code': '+260'},
    {'file': 'zimbabwe_flag.webp', 'name': 'Zimbabwe', 'code': '+263'}
  ];

  List<Map<String, String>> _filteredCountries = [];
  String? selectedCode;
  String? selectedFlag;

  @override
  void initState() {
    super.initState();
    _filteredCountries = _allCountries;
    selectedCode = _allCountries[39]['code'];
    selectedFlag = _allCountries[39]['file'];
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _allCountries.where((country) {
        final name = country['name']!.toLowerCase();
        final code = country['code']!;
        return name.contains(query.toLowerCase()) || code.contains(query);
      }).toList();
    });
  }

  void _showCountrySheet() {
    // Reset filtered list every time bottom sheet opens
    setState(() {
      _filteredCountries = _allCountries;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: UColors.boxHighlightColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: _filterCountries,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search country or code',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black26,
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _filteredCountries.length,
                  separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white24, height: 1),
                  itemBuilder: (context, index) {
                    final country = _filteredCountries[index];
                    return ListTile(
                      leading: ClipOval(
                        child: Image.asset(
                          'assets/african_flags/${country['file']}',
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        country['name']!,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      trailing: Text(
                        country['code']!,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      onTap: () {
                        setState(() {
                          selectedCode = country['code'];
                          selectedFlag = country['file'];
                        });
                        widget.onChanged(selectedCode!, selectedFlag!);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showCountrySheet,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white24),
          color: UColors.boxHighlightColor,
        ),
        child: Row(
          children: [
            if (selectedFlag != null)
              ClipOval(
                child: Image.asset(
                  'assets/african_flags/$selectedFlag',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 10),
            Text(
              selectedCode ?? '',
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            SizedBox(
              width: 10.51,
              height: 10.5,
              child: SvgPicture.asset(
                UIcons.dropdownIcon,
                fit: BoxFit.contain,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
