import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_controller.dart';
import '../../models/activity_model.dart';

class AddActivityModal extends StatefulWidget {
  final ActivityType activityType;
  final String? transportationType;
  final String? foodType;
  final String? energyType;
  final String? shoppingType;
  final String? otherType;
  final bool isRenewable;

  const AddActivityModal({
    super.key,
    required this.activityType,
    this.transportationType,
    this.foodType,
    this.energyType,
    this.shoppingType,
    this.otherType,
    this.isRenewable = false,
  });

  @override
  State<AddActivityModal> createState() => _AddActivityModalState();
}

class _AddActivityModalState extends State<AddActivityModal> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _consumptionController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isLocal = false;
  bool _isOrganic = false;
  bool _isVegetarian = false;
  int _passengers = 1;
  String _selectedUnit = 'kWh';
  bool _isLoading = false;

  @override
  void dispose() {
    _distanceController.dispose();
    _quantityController.dispose();
    _consumptionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildFormFields(),
                          const SizedBox(height: 32),
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add ${_getActivityTitle()}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getActivityDescription(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    switch (widget.activityType) {
      case ActivityType.transportation:
        return _buildTransportationFields();
      case ActivityType.food:
        return _buildFoodFields();
      case ActivityType.energy:
        return _buildEnergyFields();
      case ActivityType.shopping:
        return _buildShoppingFields();
      case ActivityType.other:
        return _buildOtherFields();
    }
  }

  Widget _buildTransportationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _distanceController,
          decoration: const InputDecoration(
            labelText: 'Distance (km)',
            hintText: 'Enter distance traveled',
            prefixIcon: Icon(Icons.straighten),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter distance';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Please enter a valid distance';
            }
            return null;
          },
        ),
        if (widget.transportationType == 'car') ...[
          const SizedBox(height: 16),
          Text(
            'Number of passengers (including driver)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Slider(
            value: _passengers.toDouble(),
            min: 1,
            max: 8,
            divisions: 7,
            label: _passengers.toString(),
            onChanged: (value) {
              setState(() {
                _passengers = value.round();
              });
            },
          ),
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            hintText: 'Add any additional details',
            prefixIcon: Icon(Icons.notes),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildFoodFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _quantityController,
          decoration: const InputDecoration(
            labelText: 'Quantity (grams)',
            hintText: 'Enter approximate weight',
            prefixIcon: Icon(Icons.scale),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter quantity';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Please enter a valid quantity';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Local/Seasonal'),
          subtitle: const Text('Reduces transportation emissions'),
          value: _isLocal,
          onChanged: (value) {
            setState(() {
              _isLocal = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Organic'),
          subtitle: const Text('Environmentally friendly farming'),
          value: _isOrganic,
          onChanged: (value) {
            setState(() {
              _isOrganic = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Vegetarian/Vegan'),
          subtitle: const Text('Plant-based option'),
          value: _isVegetarian,
          onChanged: (value) {
            setState(() {
              _isVegetarian = value ?? false;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            hintText: 'Meal details, restaurant, etc.',
            prefixIcon: Icon(Icons.notes),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildEnergyFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _consumptionController,
                decoration: const InputDecoration(
                  labelText: 'Consumption',
                  hintText: 'Enter amount',
                  prefixIcon: Icon(Icons.flash_on),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter consumption';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedUnit,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                ),
                items: ['kWh', 'MWh', 'm³'].map((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUnit = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            hintText: 'Time period, appliances used, etc.',
            prefixIcon: Icon(Icons.notes),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildShoppingFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Item Description',
            hintText: 'What did you buy?',
            prefixIcon: Icon(Icons.shopping_bag),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please describe the item';
            }
            return null;
          },
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        Text(
          'Additional Information',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Minimal packaging'),
          subtitle: const Text('Less waste generated'),
          value: _isLocal,
          onChanged: (value) {
            setState(() {
              _isLocal = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Sustainable brand'),
          subtitle: const Text('Environmentally conscious company'),
          value: _isOrganic,
          onChanged: (value) {
            setState(() {
              _isOrganic = value ?? false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildOtherFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Activity Description',
            hintText: 'Describe what you did',
            prefixIcon: Icon(Icons.eco),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please describe the activity';
            }
            return null;
          },
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitActivity,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Log Activity'),
      ),
    );
  }

  String _getActivityTitle() {
    switch (widget.activityType) {
      case ActivityType.transportation:
        return '${widget.transportationType?.toUpperCase()} Trip';
      case ActivityType.food:
        return '${widget.foodType?.replaceAll('_', ' ').toUpperCase()} Meal';
      case ActivityType.energy:
        return '${widget.energyType?.toUpperCase()} Usage';
      case ActivityType.shopping:
        return 'Shopping Activity';
      case ActivityType.other:
        return 'Other Activity';
    }
  }

  String _getActivityDescription() {
    switch (widget.activityType) {
      case ActivityType.transportation:
        return 'Log your travel distance and method';
      case ActivityType.food:
        return 'Track your meal and dietary choices';
      case ActivityType.energy:
        return 'Record your energy consumption';
      case ActivityType.shopping:
        return 'Log your purchases and shopping habits';
      case ActivityType.other:
        return 'Record other environmental activities';
    }
  }

  Future<void> _submitActivity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final userController = Provider.of<UserController>(context, listen: false);

    try {
      switch (widget.activityType) {
        case ActivityType.transportation:
          await userController.addTransportationActivity(
            transportType: widget.transportationType!,
            distance: double.parse(_distanceController.text),
            passengers: _passengers,
          );
          break;
        case ActivityType.food:
          await userController.addFoodActivity(
            foodName: widget.foodType!.replaceAll('_', ' '),
            quantity: double.parse(_quantityController.text),
            foodType: widget.foodType!,
            isLocal: _isLocal,
            isOrganic: _isOrganic,
            isVegetarian: _isVegetarian,
          );
          break;
        case ActivityType.energy:
          await userController.addEnergyActivity(
            energyType: widget.energyType!,
            consumption: double.parse(_consumptionController.text),
            unit: _selectedUnit,
            isRenewable: widget.isRenewable,
          );
          break;
        case ActivityType.shopping:
        case ActivityType.other:
          // For shopping and other activities, we'll create a generic activity
          // In a real app, you'd have specific handling for these
          break;
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activity logged successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging activity: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
