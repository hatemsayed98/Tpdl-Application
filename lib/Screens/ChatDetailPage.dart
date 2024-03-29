import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gp_version_01/Accessories/constants.dart';
import 'package:gp_version_01/Controller/chatController.dart';
import 'package:gp_version_01/Controller/userController.dart';
import 'package:gp_version_01/models/ChatMessage.dart';
import 'package:gp_version_01/models/ChatUsers.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as os;

final _firestore = FirebaseFirestore.instance;

class ChatDetailPage extends StatefulWidget {
  static const String route = "ChatDetailPage";
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String currentUserIsSender;
  String currentUserIsNotSender;

  bool flag = true;
  ChatUsers user;
  String name;
  bool check;
  String messageText;

  @override
  void didChangeDependencies() {
    if (flag == true) {
      Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
      print(args);
      check = args['flag'];
      if (check) {
        user = args['obj'];
        name = user.tempName;
      } else {
        name =
            Provider.of<UserController>(context, listen: false).otherUserName;
        user = Provider.of<ChatController>(context, listen: false).chatUser;
      }
    }
    flag = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (user.receiverId == FirebaseAuth.instance.currentUser.uid) {
      currentUserIsSender =
          FirebaseAuth.instance.currentUser.uid + '_' + user.senderId;
      currentUserIsNotSender =
          user.senderId + '_' + FirebaseAuth.instance.currentUser.uid;
    } else {
      currentUserIsSender =
          FirebaseAuth.instance.currentUser.uid + '_' + user.receiverId;
      currentUserIsNotSender =
          user.receiverId + '_' + FirebaseAuth.instance.currentUser.uid;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/User_font_awesome.svg/1200px-User_font_awesome.svg.png"),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              currentUserIsNotSender: currentUserIsNotSender,
              currentUserIsSender: currentUserIsSender,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      try {
                        if (messageText != null) {
                          String temp;
                          messageTextController.clear();
                          QuerySnapshot snapshot = await _firestore
                              .collection('Chat')
                              .where("fromId_toId", whereIn: [
                            currentUserIsSender,
                            currentUserIsNotSender
                          ]).get();
                          snapshot.docs.forEach((element) {
                            temp = element["fromId_toId"];
                            element.reference.set({
                              'lastText': messageText,
                              'time': Timestamp.now(),
                            }, SetOptions(merge: true));
                            element.reference.collection("Message").add({
                              'messageContent': messageText,
                              'sender': FirebaseAuth.instance.currentUser.uid,
                              'time': Timestamp.now(),
                            });
                          });

                          Provider.of<ChatController>(context, listen: false)
                              .addMessage(
                                  temp,
                                  messageText,
                                  FirebaseAuth.instance.currentUser.uid,
                                  Timestamp.now());
                        }
                      } catch (e) {}
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String currentUserIsSender;
  final String currentUserIsNotSender;

  MessagesStream({this.currentUserIsNotSender, this.currentUserIsSender});
  @override
  Widget build(BuildContext context) {
    String docId =
        Provider.of<ChatController>(context, listen: false).documentId;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Chat')
          .doc(docId)
          .collection("Message")
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['messageContent'];
          final messageTime = message['time'];
          final messageBubble = MessageBubble(
            time: messageTime,
            text: messageText,
            isMe: FirebaseAuth.instance.currentUser.uid == message['sender'],
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.time, this.text, this.isMe});

  final Timestamp time;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            os.DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
                time.millisecondsSinceEpoch)),
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
