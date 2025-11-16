import 'package:flutter/material.dart';
import '../services/mock_voice_service.dart';

/// Debug panel for testing mock voice commands
class MockVoicePanel extends StatefulWidget {
  final MockVoiceService mockVoiceService;
  
  const MockVoicePanel({
    super.key,
    required this.mockVoiceService,
  });
  
  @override
  State<MockVoicePanel> createState() => _MockVoicePanelState();
}

class _MockVoicePanelState extends State<MockVoicePanel> {
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Commands panel
          if (_isExpanded) _buildCommandsPanel(),
          
          const SizedBox(height: 10),
          
          // Toggle button
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            backgroundColor: Colors.orange,
            child: Icon(_isExpanded ? Icons.close : Icons.list),
            heroTag: 'mock_panel',
          ),
        ],
      ),
    );
  }
  
  Widget _buildCommandsPanel() {
    return Container(
      width: 350,
      constraints: const BoxConstraints(maxHeight: 600),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.science, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Mock Voice Commands',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tabs
            const TabBar(
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.orange,
              tabs: [
                Tab(text: 'Quick Commands'),
                Tab(text: 'Use Cases'),
              ],
            ),
            
            // Tab content
            Flexible(
              child: TabBarView(
                children: [
                  _buildQuickCommandsTab(),
                  _buildUseCasesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickCommandsTab() {
    final commands = widget.mockVoiceService.getMockCommands();
    
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: commands.length,
      itemBuilder: (context, index) {
        final command = commands[index];
        
        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.mic, color: Colors.orange, size: 20),
            title: Text(
              command,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            dense: true,
            onTap: () {
              widget.mockVoiceService.startListeningWithCommand(command);
            },
            trailing: const Icon(
              Icons.play_arrow,
              color: Colors.orange,
              size: 20,
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildUseCasesTab() {
    final useCases = widget.mockVoiceService.getUseCases();
    
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: useCases.length,
      itemBuilder: (context, index) {
        final useCase = useCases[index];
        
        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ExpansionTile(
            leading: const Icon(Icons.psychology, color: Colors.orange, size: 20),
            title: Text(
              useCase.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            subtitle: Text(
              useCase.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_circle, color: Colors.green),
              onPressed: () {
                widget.mockVoiceService.executeUseCase(useCase);
              },
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Commands:',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...useCase.commands.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

