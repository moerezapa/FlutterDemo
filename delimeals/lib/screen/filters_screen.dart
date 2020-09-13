import 'package:delimeals/widget/main_drawer.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {

  static const routeName = '/filter-screen';

  final Function saveFilters;
  Map<String, bool> currentFilters;
  FilterScreen(this.currentFilters, this.saveFilters);
  
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  /**
   * For code improvement
   * use var instead bool
   */

  /// ini gausah diinisialisasi false lagi by default soalnya
  /// udah di pass data dari main.dart. inisialisasi di initState aja
  var _glutenFree = false;
  var _vegetarian = false;
  var _vegan = false;
  var _lactoseFree = false;

  @override
  void initState() { 
    _glutenFree = widget.currentFilters['gluten'];
    _vegetarian = widget.currentFilters['vegetarian'];
    _vegan = widget.currentFilters['vegan'];
    _lactoseFree = widget.currentFilters['lactose'];
    super.initState();
  }

  Widget _buildSwitchListTile(String title, String subtitle, bool currentValue, Function updateValue) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: currentValue, 
      onChanged: updateValue
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        appBar: AppBar(
          title: Text('Your Filters'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save), 
              onPressed: () {
                final selectedFilters = {
                  'gluten' : _glutenFree,
                  'lactose' : _lactoseFree,
                  'vegan' : _vegan,
                  'vegetarian' : _vegetarian,
                };
                widget.saveFilters(selectedFilters);
              }
            )
          ],
        ),

        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Adjust your meal selection',
                style: Theme.of(context).textTheme.title,  
              ),
            ),

            // expanded is a widget that ensure its child takes up
            // as much space it can get
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildSwitchListTile(
                    'Gluten-free', 
                    'Only include gluten-free meals.', 
                    _glutenFree, 
                    (newValue) {
                      setState(() {
                        _glutenFree = newValue;
                      });
                    }
                  ),
                  _buildSwitchListTile(
                    'Lactose-free', 
                    'Only include lactose-free meals.', 
                    _lactoseFree, 
                    (newValue) {
                      setState(() {
                        _lactoseFree = newValue;
                      });
                    }
                  ),
                  _buildSwitchListTile(
                    'Vegetarian', 
                    'Only include vegetarian meals.', 
                    _vegetarian, 
                    (newValue) {
                      setState(() {
                        _vegetarian = newValue;
                      });
                    }
                  ),
                  _buildSwitchListTile(
                    'Vegan', 
                    'Only include vegan meals.', 
                    _vegan, 
                    (newValue) {
                      setState(() {
                        _vegan = newValue;
                      });
                    }
                  ),
                ],
              )
            ),
          ],
        ),

        drawer: MainDrawer(),
    );
  }
}