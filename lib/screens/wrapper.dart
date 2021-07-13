import 'dart:async';
import 'package:Paperless_Workflow/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:Paperless_Workflow/repository/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  AuthenticationBloc authenticationBloc;
  PermissionService _permissionService = PermissionService();


  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    _permissionService.requestStoragePermission().then((value)  {
        _permissionService.requestMicrophonePermission();
    });

    Timer.periodic(Duration(seconds: 4), (timer) {
      authenticationBloc.add(CheckAuthentication());
      BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context,state) {
          print(state);
        }
      );
      if(authenticationBloc.state is AuthenticateUserState) {
        authenticationBloc.close();
        timer.cancel();
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body:BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {

          print("========${state}");
          if (state is AuthenticationSuccess) {
            authenticationBloc.add(GetAuthenticatedUser());
          } else if (state is AuthenticateUserState) {
            String userRole = state.user.userRole;

            if(userRole == 'student') {
              authenticationBloc.close();
              Navigator.pushNamed(context, '/requests');

            } else {
              authenticationBloc.close();
              Navigator.pushNamed(context, '/authority_requests');
            }

          } else if (state is AuthenticationFails) {
            Navigator.pushNamed(context, '/login');
          }
        },
        child:  Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                new Color(0xffC9AFCB),
                new Color(0xffC9AFCB),
                new Color(0xff9C899E),
                new Color(0xff746575),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.only(top: _height / 4),
            children: [
              Image.asset(
                'assets/paperless.png',
                height: _height / 3.5,
                width: _width / 2,
              ),
              SizedBox(
                width: 446.0,
                child: Text(
                  'PAPERLESS WORKFLOW',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 30,
                    color: const Color(0xff300950),
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        // child: Container(
        //   alignment: Alignment.center,
        //   child: Stack(
        //     alignment: Alignment.center,
        //     children: <Widget>[
        //       Opacity(
        //         opacity: .5,
        //         child: Image.asset('assets/bg.png'),
        //       ),
        //       Shimmer.fromColors(
        //       // period: Duration(milliseconds: 1500),
        //       baseColor: Colors.red,
        //       highlightColor: Color(0xfeb6965),
        //       child: Container(
        //         padding: EdgeInsets.all(16.0),
        //         child: Text(
        //           "Paperless Workflow",
        //           style: TextStyle(
        //             fontSize: 26.0,
        //             fontFamily: 'Pacifico',
        //             shadows: <Shadow>[
        //               Shadow(
        //                 blurRadius: 18.0,
        //                 color: Colors.black87,
        //                 offset: Offset.fromDirection(120, 12)
        //               )
        //             ]
        //           ),
        //         ),
        //       ),
        //     )
        //     ],
        //   ),
        // )
      )
    );
  }
}

