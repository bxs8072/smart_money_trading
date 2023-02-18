import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/apis/benzinga_api.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/services/size_service.dart';

class NewsPage extends StatefulWidget {
  final Customer customer;
  const NewsPage({super.key, required this.customer});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String category = "stock";

  List<String> categories = ["stock", "technology", "finance"];
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          key: widget.key,
          title: Row(
            children: [
              Text(
                "NEWS",
                style: GoogleFonts.righteous(
                  fontSize: SizeService(context).height * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  elevation: 0.0,
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(12.0),
                    underline: const Center(),
                    elevation: 6,
                    hint: const Text("Select Category"),
                    isExpanded: true,
                    key: widget.key,
                    value: category,
                    items: categories
                        .map(
                          (e) => DropdownMenuItem<String>(
                            key: Key(e),
                            value: e,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(e.toUpperCase())),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        category = val!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
            initialData: [],
            future: BenzingaApi().getNewsByCategory(category),
            builder: (context, snapshot) {
              List<Map<String, dynamic>> list = snapshot.data!
                  .where((element) => element['image'].length > 1)
                  .toList();
              return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                return Card(
                  elevation: 0.00,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          list[i]["image"][2]["url"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          list[i]["title"],
                        ),
                        Text(
                          '~ ${list[i]["author"]}',
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: list.length));
            }),
      ],
    );
  }
}
