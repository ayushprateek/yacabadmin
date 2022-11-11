import 'package:flutter/material.dart';
enum status{pending,approved,disaproved}
class StatusName
{
  static String name="Pending";
  static status s=status.pending;
}
class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            setState(() {
              StatusName.s=status.pending;
            });
          },
          child: Row(
            children: [
              Radio(
                value: StatusName.s,
                groupValue: status.pending, onChanged: (status? value) {
                setState(() {
                  StatusName.s=status.pending;
                });
              },
              ),
              Text("Pending",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 17
              ),),
            ],
          ),
        ),

        InkWell(
          onTap: (){
            setState(() {
              StatusName.s=status.approved;
            });
          },
          child: Row(
            children: [
              Radio(
                value: StatusName.s,
                groupValue: status.approved, onChanged: (status? value) {
                setState(() {
                  StatusName.s=status.approved;
                });
              },
              ),
              Text("Approved",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17
                ),),
            ],
          ),
        ),

        InkWell(
          onTap: (){
            setState(() {
              StatusName.s=status.disaproved;
            });
          },
          child: Row(
            children: [
              Radio(
                value: StatusName.s,
                groupValue: status.disaproved, onChanged: (status? value) {
                setState(() {
                  StatusName.s=status.disaproved;
                });
              },
              ),
              Text("Disapproved",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17
                ),),
            ],
          ),
        ),

      ],
    );
  }
}
