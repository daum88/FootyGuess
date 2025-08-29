import 'package:flutter/material.dart';
import '../../../data/models/player.dart';

class PlayerSearch extends StatefulWidget {
  final Function(Player) onPlayerSelected;
  final List<Player> players;
  final Function(String) onSearchChanged;
  final String searchQuery;

  const PlayerSearch({
    super.key,
    required this.onPlayerSelected,
    required this.players,
    required this.onSearchChanged,
    required this.searchQuery,
  });

  @override
  State<PlayerSearch> createState() => _PlayerSearchState();
}

class _PlayerSearchState extends State<PlayerSearch> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchQuery;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Search for a player...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        widget.onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: widget.onSearchChanged,
          ),
          if (_controller.text.isNotEmpty && widget.players.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.players.length,
                itemBuilder: (context, index) {
                  final player = widget.players[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Text(
                        player.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(player.name),
                    subtitle:
                        Text('${player.position} • ${player.currentClub}'),
                    onTap: () {
                      widget.onPlayerSelected(player);
                      _controller.clear();
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
