import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';

class FancyButton extends StatelessWidget{

  FancyButton({this.onPressed});
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context){
    return RawMaterialButton(
      child: Text("(<O>-<O>)"),
      fillColor: Colors.blueGrey,
      onPressed: onPressed,
      shape: StadiumBorder(),
    );
  }
}
