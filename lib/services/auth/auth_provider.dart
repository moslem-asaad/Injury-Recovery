import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injury_recovery/services/auth/auth_user.dart';

abstract class AuthProvider{
  Future<void> initialize();
  AuthUser? get currentUser;
  
  Future<AuthUser> logIn({
    required String email, 
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<void> resetPassword({required String email});

  UploadTask? uploadFile(String destination,File file);
  
}