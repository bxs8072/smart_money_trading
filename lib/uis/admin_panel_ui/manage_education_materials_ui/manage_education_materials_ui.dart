import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/education_material.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/manage_education_materials_ui/add_education_material_ui.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/manage_education_materials_ui/edit_education_material_ui.dart';

class ManageEducationMaterialsUI extends StatefulWidget {
  const ManageEducationMaterialsUI({super.key});

  @override
  State<ManageEducationMaterialsUI> createState() =>
      _ManageEducationMaterialsUIState();
}

class _ManageEducationMaterialsUIState
    extends State<ManageEducationMaterialsUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        elevation: 0.0,
        onPressed: () {
          NavigationService(context).push(
            AddEducationMaterialUI(
              key: widget.key,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            key: widget.key,
            title: const Text("Manage OXT Education Materials"),
            pinned: true,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("educationMaterials")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        key: widget.key,
                      ),
                    ),
                  );
                }

                List<EducationMaterial> educationMaterialList = snapshot
                    .data!.docs
                    .map((doc) => EducationMaterial.fromDocumentSnapshot(doc))
                    .toList();

                return SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        EducationMaterial educationMaterial =
                            educationMaterialList[index];
                        return Card(
                          elevation: 0.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12.0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black87,
                              child: Text(
                                "${index + 1}",
                                style: GoogleFonts.exo2(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            title: Text(educationMaterial.title),
                            subtitle: Text(educationMaterial.subtitle),
                            onTap: () {
                              NavigationService(context).push(
                                EditEducationMaterialUI(
                                    educationMaterial: educationMaterial),
                              );
                            },
                          ),
                        );
                      },
                      childCount: educationMaterialList.length,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
