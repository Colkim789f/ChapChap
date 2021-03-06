import 'package:client/core/models/garage.dart';
import 'package:client/router/roles.dart';
import 'package:client/screens/auth/login.dart';
import 'package:client/styles/icons/chap_chap_icons.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Dialog(
          backgroundColor: AppColors.bgDark,
          insetPadding:
              const EdgeInsets.only(top: 24, bottom: 24, right: 10, left: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AddAdmin extends StatelessWidget {
  const AddAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Administrator ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: "SF Pro Rounded",
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            style: const TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.input,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.success,
                  width: 2,
                ),
              ),
              hintText: "Search for User",
            ),
          ),
          const SizedBox(height: 25),
          Expanded(flex: 4, child: getUsers()),
        ],
      ),
    );
  }

  Widget getUsers() {
    return ListView.separated(
      padding: const EdgeInsets.all(5),
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      itemCount: 20,
      itemBuilder: (_, i) {
        return RoundedTile(
          label: "User ${i.toString()}",
          avatar: getImage(),
          icon: const Icon(ChapChap.add),
        );
      },
    );
  }
}

class RoundedTile extends StatelessWidget {
  const RoundedTile({
    Key? key,
    required this.label,
    required this.icon,
    required this.avatar,
  }) : super(key: key);

  final String label;
  final Widget icon;
  final Widget avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: avatar,
          ),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: "SF Pro Rounded",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
            ),
            child: icon,
          ),
        ],
      ),
    );
  }
}

class AddGarage extends StatelessWidget {
  AddGarage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _userFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Garage",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: "SF Pro Rounded",
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 25),
              garageInfo(),
              const SizedBox(height: 25),
              garageDescription(),
              const SizedBox(height: 25),
              garageAddress(),
              const SizedBox(height: 25),
              garageAdminUser(),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseFirestore.instance.collection("garage").doc().set({
                      "name": _nameController.text,
                      "description": _descriptionController.text,
                      "image":
                          "https://ui-avatars.com/api/?name=\"${_nameController.text}\"&background=f2f2f2&color=fff",
                      "address": Address(
                              name: _nameController.text,
                              position: LatLng(-0.303099, 36.080025))
                          .toFirestore(),
                      "userUid": FirebaseAuth.instance.currentUser!.uid,
                    }).then((value) =>
                        Navigator.of(context, rootNavigator: true).pop());
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Request for Access",
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // createGarage({required BuildContext context, required Garage garage}) {
  //   Provider.of<AppData>(context).createGarage(garage: garage);
  // }

  garageAdminUser() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Garage Admin User",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "SF Pro Rounded",
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _userController,
          focusNode: _userFocusNode,
          style: const TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
          decoration: InputDecoration(
            hintText: "User responsible for the garage",
            filled: true,
            isCollapsed: true,
            prefixIcon: const Icon(ChapChap.user, size: 20),
            contentPadding:
                const EdgeInsets.only(top: 24, bottom: 24, left: 15, right: 10),
            fillColor: AppColors.input,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  garageAddress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Garage Address",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "SF Pro Rounded",
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _addressController,
          focusNode: _addressFocusNode,
          onSaved: (val) {},
          style: const TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
          decoration: InputDecoration(
            hintText: "Add your Address",
            filled: true,
            isCollapsed: true,
            suffixIcon: const Icon(ChapChap.location, size: 20),
            contentPadding:
                const EdgeInsets.only(top: 24, bottom: 24, left: 15),
            fillColor: AppColors.input,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  garageDescription() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Garage Description",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: "SF Pro Rounded",
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          focusNode: _descriptionFocusNode,
          validator: (value) => Validator.validateName(name: value!),
          minLines: 4,
          maxLines: 5,
          style: const TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
          decoration: InputDecoration(
            filled: true,
            isCollapsed: true,
            contentPadding: const EdgeInsets.fromLTRB(15, 20, 5, 20),
            fillColor: AppColors.input,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Row garageInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 78,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.bgDark,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.149),
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: getImage(),
            ),
            const SizedBox(height: 5),
            const Text(
              "Garage Image",
              style: TextStyle(
                color: Color.fromRGBO(106, 106, 106, 1),
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextFormField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            validator: (value) => Validator.validateName(name: value!),
            style: const TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
            decoration: InputDecoration(
              filled: true,
              hintText: "Garage Name",
              isCollapsed: true,
              contentPadding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
              fillColor: AppColors.input,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

getImage() {
  return Image.asset(
    'assets/images/img/garage.png',
    errorBuilder: (_, __, ___) {
      return const FlutterLogo(size: 78);
    },
  );
}
