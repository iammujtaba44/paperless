import 'package:flutter/material.dart';

class CustomWidgets {
  Widget errorOrSuccessMessage({@required String type, @required String msg}) {
    Color boxColor;
    Color textColor;

    if (type == 'error') {
      boxColor = Colors.red[100];
      textColor = Colors.red;
    } else {
      boxColor =Colors.green[100];
      textColor = Colors.green;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Text(msg, style: TextStyle(
        color: textColor,
        fontSize: 15
      ),),
    );
  }

  void showSnackBar(BuildContext context, String content, Duration duration)  {
    SnackBar snackbar = SnackBar(
      content: Text(content),
      duration: duration,
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }

  void offKeyboardFocus({@required BuildContext context}) {
      FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget loadInProgress() {
    return Scaffold(
    body: Container(
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
      child:Center(child: CircularProgressIndicator(),),
    ),
    );
  }
}
