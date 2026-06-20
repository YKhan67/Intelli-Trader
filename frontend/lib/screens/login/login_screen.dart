import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/enums.dart';
import '../../state/providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../utils/logger.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _urlController = TextEditingController(text: "http://localhost:8081");
  final _apiKeyController = TextEditingController();
  bool _obscureApiKey = true;
  bool _backendTested = false;
  String? _backendError;

  BrokerType _selectedBroker = BrokerType.mt5;
  final _mt5BridgeController = TextEditingController(text: "ws://localhost:8765");
  final _mt4BridgeController = TextEditingController(text: "ws://localhost:8764");
  final _oandaAccountIdController = TextEditingController();
  final _oandaTokenController = TextEditingController();
  bool _obscureOandaToken = true;
  bool _oandaLive = false;
  bool _brokerTested = false;
  String? _brokerError;

  bool _isTestingBackend = false;
  bool _isTestingBroker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ForexAI Setup"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Connect your backend and broker",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildSectionTitle("1. Backend Connection"),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: "Backend URL",
                hintText: "http://localhost:8000",
              ),
              onChanged: (_) => setState(() => _backendTested = false),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _apiKeyController,
              obscureText: _obscureApiKey,
              decoration: InputDecoration(
                labelText: "API Key",
                suffixIcon: IconButton(
                  icon: Icon(_obscureApiKey ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureApiKey = !_obscureApiKey),
                ),
              ),
              onChanged: (_) => setState(() => _backendTested = false),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isTestingBackend ? null : _testBackendConnection,
                  child: _isTestingBackend 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Test Connection"),
                ),
                if (_backendTested) ...[
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.check_circle, color: AppColors.buyGreen),
                ],
              ],
            ),
            if (_backendError != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(_backendError!, style: const TextStyle(color: AppColors.sellRed)),
              ),

            const SizedBox(height: AppSpacing.xl),

            _buildSectionTitle("2. Broker Selection"),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<BrokerType>(
              value: _selectedBroker,
              decoration: const InputDecoration(labelText: "Broker Type"),
              items: BrokerType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedBroker = value;
                    _brokerTested = false;
                  });
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildBrokerFields(),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isTestingBroker ? null : _testBrokerConnection,
                  child: _isTestingBroker
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Test Broker Connection"),
                ),
                if (_brokerTested) ...[
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.check_circle, color: AppColors.buyGreen),
                ],
              ],
            ),
            if (_brokerError != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(_brokerError!, style: const TextStyle(color: AppColors.sellRed)),
              ),

            const SizedBox(height: AppSpacing.xxl),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_backendTested && _brokerTested) ? _saveAndContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,
                  disabledBackgroundColor: AppColors.backgroundElevated,
                ),
                child: const Text("Save and Continue", style: TextStyle(fontSize: 18)),
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            _buildInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.accentBlue),
    );
  }

  Widget _buildBrokerFields() {
    switch (_selectedBroker) {
      case BrokerType.mt5:
        return TextField(
          controller: _mt5BridgeController,
          decoration: const InputDecoration(
            labelText: "Bridge URL",
            hintText: "ws://localhost:8765",
          ),
          onChanged: (_) => setState(() => _brokerTested = false),
        );
      case BrokerType.mt4:
        return TextField(
          controller: _mt4BridgeController,
          decoration: const InputDecoration(
            labelText: "Bridge URL",
            hintText: "ws://localhost:8764",
          ),
          onChanged: (_) => setState(() => _brokerTested = false),
        );
      case BrokerType.oanda:
        return Column(
          children: [
            TextField(
              controller: _oandaAccountIdController,
              decoration: const InputDecoration(labelText: "Account ID"),
              onChanged: (_) => setState(() => _brokerTested = false),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _oandaTokenController,
              obscureText: _obscureOandaToken,
              decoration: InputDecoration(
                labelText: "API Token",
                suffixIcon: IconButton(
                  icon: Icon(_obscureOandaToken ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureOandaToken = !_obscureOandaToken),
                ),
              ),
              onChanged: (_) => setState(() => _brokerTested = false),
            ),
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              title: const Text("Live Environment"),
              subtitle: Text(_oandaLive ? "Connects to api-fxtrade.oanda.com" : "Connects to api-fxpractice.oanda.com"),
              value: _oandaLive,
              onChanged: (val) => setState(() {
                _oandaLive = val;
                _brokerTested = false;
              }),
            ),
          ],
        );
    }
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Instructions:",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentBlue),
          ),
          SizedBox(height: 4),
          Text(
            "• For MT5/MT4 install the ForexAI EA in MetaTrader.",
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
          Text(
            "• For OANDA use your v20 API key from the OANDA portal.",
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Future<void> _testBackendConnection() async {
    final url = _urlController.text.trim();
    final key = _apiKeyController.text.trim();

    if (url.isEmpty || !url.startsWith('http')) {
      setState(() => _backendError = "Invalid Backend URL. Must start with http:// or https://");
      return;
    }

    setState(() {
      _isTestingBackend = true;
      _backendError = null;
    });

    try {
      final backend = ref.read(backendServiceProvider);
      final status = await backend.testConnection(url, key);
      
      if (status.isNotEmpty) {
        setState(() {
          _backendTested = true;
          _backendError = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Backend connection successful!"), backgroundColor: AppColors.buyGreen),
          );
        }
      }
    } catch (e) {
      logger.e("Backend test failed: $e");
      setState(() {
        _backendTested = false;
        _backendError = e.toString();
      });
    } finally {
      if (mounted) setState(() => _isTestingBackend = false);
    }
  }

  Future<void> _testBrokerConnection() async {
    setState(() {
      _isTestingBroker = true;
      _brokerError = null;
    });

    try {
      final Map<String, String> credentials = {};
      if (_selectedBroker == BrokerType.oanda) {
        final accountId = _oandaAccountIdController.text.trim();
        final token = _oandaTokenController.text.trim();
        if (accountId.isEmpty || token.isEmpty) {
          throw "OANDA Account ID and Token are required";
        }
        credentials['api_token'] = token;
        credentials['account_id'] = accountId;
        credentials['environment'] = _oandaLive ? 'live' : 'practice';
      } else {
        final bridgeUrl = _selectedBroker == BrokerType.mt5 
          ? _mt5BridgeController.text.trim() 
          : _mt4BridgeController.text.trim();
        if (bridgeUrl.isEmpty) throw "Bridge URL is required";
        credentials['bridge_url'] = bridgeUrl;
      }

      final brokerNotifier = ref.read(brokerConnectionProvider.notifier);
      final success = await brokerNotifier.connect(_selectedBroker, credentials);
      
      if (success) {
        setState(() {
          _brokerTested = true;
          _brokerError = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Broker connection successful!"), backgroundColor: AppColors.buyGreen),
          );
        }
      } else {
        setState(() => _brokerError = "Broker connection failed. Please check your credentials.");
      }
    } catch (e) {
      logger.e("Broker test failed: $e");
      setState(() {
        _brokerTested = false;
        _brokerError = e.toString();
      });
    } finally {
      if (mounted) setState(() => _isTestingBroker = false);
    }
  }

  Future<void> _saveAndContinue() async {
    try {
      final storage = ref.read(storageServiceProvider);
      
      // Save backend config
      await storage.saveBackendConfig(_urlController.text.trim(), _apiKeyController.text.trim());
      
      // Save broker config
      final Map<String, String> credentials = {};
      if (_selectedBroker == BrokerType.oanda) {
        credentials['api_token'] = _oandaTokenController.text.trim();
        credentials['account_id'] = _oandaAccountIdController.text.trim();
        credentials['environment'] = _oandaLive ? 'live' : 'practice';
      } else {
        credentials['bridge_url'] = _selectedBroker == BrokerType.mt5 
          ? _mt5BridgeController.text.trim() 
          : _mt4BridgeController.text.trim();
      }
      await storage.saveBrokerConfig(_selectedBroker, credentials);
      
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      logger.e("Final save failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving configuration: $e"), backgroundColor: AppColors.sellRed),
        );
      }
    }
  }
}
