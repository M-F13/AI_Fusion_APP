import 'package:flutter/material.dart';

import '../helper/global.dart';
import '../model/message.dart';


class MessageCard extends StatelessWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: mq.height * .01,
        horizontal: mq.width * .02,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.msgType == MessageType.bot) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.auto_awesome, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: message.msgType == MessageType.bot
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.msgType == MessageType.bot
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: message.msgType == MessageType.bot
                          ? const Radius.circular(0)
                          : const Radius.circular(12),
                      bottomRight: message.msgType == MessageType.bot
                          ? const Radius.circular(12)
                          : const Radius.circular(0),
                    ),
                  ),
                  child: message.msg.isEmpty
                      ? const Text('Thinking...')
                      : SelectableText(
                    message.msg,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          if (message.msgType == MessageType.user) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}










