import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/education_material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/uis/pdf_view_ui/pdf_view_ui.dart';

class EducationalMaterialUI extends StatefulWidget {
  const EducationalMaterialUI({super.key});

  @override
  State<EducationalMaterialUI> createState() => _EducationalMaterialUIState();
}

class _EducationalMaterialUIState extends State<EducationalMaterialUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text("Educational Material"),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("educationMaterials")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(
                        child: CircularProgressIndicator(key: widget.key)),
                  );
                }
                List<EducationMaterial> educationMaterialList = snapshot
                    .data!.docs
                    .map((doc) => EducationMaterial.fromDocumentSnapshot(doc))
                    .toList();
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      EducationMaterial item = educationMaterialList[index];
                      return MaterialItemWidget(
                        item: item,
                        onTap: () {
                          // Push to the PDF view UI with the selected item details
                          NavigationService(context).push(
                            PdfViewUI(
                              pdfLink: item.pdfUrl,
                              key: ValueKey(item
                                  .title), // Ensure key is unique for each PDF
                            ),
                          );
                        },
                      );
                    },
                    childCount: educationMaterialList.length,
                  ),
                );
              }),
        ],
      ),
    );
  }
}

// Define a model for material items
class MaterialItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String pdfLink;
  final Timestamp createdAt;

  MaterialItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.pdfLink,
    required this.createdAt,
  });
}

// Define a widget for material items
class MaterialItemWidget extends StatelessWidget {
  final EducationMaterial item;
  final VoidCallback onTap;

  const MaterialItemWidget(
      {required this.item, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      leading: Image.network(
          item.imageUrl), // Replace with a network image if necessary
      title: Text(item.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(item.subtitle),
          Text(
            '~${timeago.format(item.createdAt.toDate())}',
            textAlign: TextAlign.end,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
