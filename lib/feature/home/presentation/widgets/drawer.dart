import 'package:chat_app/core/navigation/routes/routes_name.dart';
import 'package:chat_app/feature/home/presentation/riverpod/update_status_controller.dart';
import 'package:chat_app/feature/home/presentation/riverpod/upload_image_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../riverpod/drawer_controller.dart';

class MyDrawer extends ConsumerStatefulWidget {
  const MyDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyDrawerState();
}

class _MyDrawerState extends ConsumerState<MyDrawer> {
  User? user;
  String? imageUrl;
  bool isActive = true;
  bool isProfileLoading = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? photoLink =
      'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg';

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(myDrawerControllerProvider.notifier).myDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myDrawerControllerProvider);
    ref.listen(myDrawerControllerProvider, (_, next) {
      if (next.value?.$1 != null && next.value?.$2 == null) {
        setState(() {
          isProfileLoading = false;
          photoLink = (next.value?.$1?.userData.photoUrl)!;
          isActive = (next.value?.$1?.userData.isActive)!;
        });
      } else {
        print(next.value?.$2);
      }
    });

    ref.listen(updateImageControllerProvider, (_, next) {
      if (next.value?.$1 != null) {
        setState(() {
          photoLink = next.value?.$1!.userData.photoUrl;
        });
      } else {
        print(next.value?.$2);
      }
    });

    ref.listen(updateStatusControllerProvider, (_, next) {
      if (next.value?.$1 != null) {
        setState(() {
          isActive = (next.value?.$1!.userData.isActive)!;
        });
      } else {
        print(next.value?.$2);
      }
    });
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: isProfileLoading
                      ? const CircularProgressIndicator()
                      : CircleAvatar(
                          backgroundImage: NetworkImage(photoLink!),
                          radius: 20,
                        ),
                  // child: CircleAvatar(
                  //   backgroundImage: NetworkImage(photoLink!),
                  // ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {
                        updateImage();
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 10,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: isActive
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green,
                          )
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text('${auth.currentUser?.displayName}'),
            Text('${auth.currentUser?.email}'),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Active status ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isActive,
                    onChanged: (isOn) {
                      setState(() {
                        isActive = isOn;
                      });
                      ref
                          .read(updateStatusControllerProvider.notifier)
                          .updateStatus(status: isActive);
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Colors.greenAccent,
                ),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  context.go(RoutesName.login);
                } on FirebaseAuthException catch (error) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error!"),
                          content: Text(error.toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      });
                }
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  void updateImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    ref.read(updateImageControllerProvider.notifier).updateImage(image: image);
  }
}
